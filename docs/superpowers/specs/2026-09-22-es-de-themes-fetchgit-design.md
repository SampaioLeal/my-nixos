# ES-DE Themes via fetchGit — Design

**Date:** 2026-09-22
**Status:** Approved

## Goal

When running `./switch-home.sh`, Nix should fetch ES-DE theme repositories at build time (pure Nix, `fetchgit`) and symlink them into `~/ES-DE/themes/`, replacing the current manual git clones and the untracked theme copies in the repo.

## Context

- ES-DE is installed via a custom AppImage derivation (`home/gaming/es-de-derivation.nix`).
- `home/gaming/default.nix` already has `home.file."ES-DE" = { source = ./es-de; recursive = true; }`.
- `./es-de/` currently contains `settings/es_settings.xml` (tracked) and `themes/` (untracked copies of 4 themes + themes-list).
- `~/ES-DE/` has real user data (collections, controllers, gamelists, downloaded_media, logs, scrapers, …) plus 5 real git clones under `themes/`.
- Runtime-writable data must remain real directories (not store symlinks).

## Decisions

1. **Pure Nix (`fetchgit` at build)** — not an imperative clone script.
2. **Fixed list in Nix** — attrset of themes, edited by hand to add/remove.
3. **Keep `home.file."ES-DE" recursive` as-is for settings** — only swap how `themes/` is populated; do not nix-manage gamelists/scrapers/etc.
4. **Per-theme `home.file` entries** (approach A) — not a single linkFarm.
5. **Fixed-output `fetchgit` with `url`, `rev`, and `hash`** — cacheable, deterministic.
6. **Exclude `themes-list`** — it is the official catalog for the theme downloader, not a selectable theme.

## Architecture

```
home/gaming/es-de-themes.nix     attrset { name = { url, rev, hash }; }
        │ import
        ▼
home/gaming/default.nix
        │ pkgs.fetchgit → /nix/store/...-source
        │ lib.mapAttrs' → home.file."ES-DE/themes/<name>".source
        ▼
home-manager switch (via switch-home.sh)
        │
        ▼
~/ES-DE/themes/<name>  → symlink → /nix/store/...-source
~/ES-DE/settings/      → symlink → ./es-de/settings (unchanged)
rest of ~/ES-DE/       → real user data, untouched
```

`switch-home.sh` itself does not change; fetching happens during the Nix build.

**Update a theme:** edit `rev` (and `hash`) → run `./switch-home.sh`.

## Theme list format

`home/gaming/es-de-themes.nix` returns an attrset; the attribute name is the directory name ES-DE expects (must match `Theme` in settings):

```nix
{
  cathode-es-de = {
    url = "https://github.com/hplant6/cathode-es-de.git";
    rev = "1de47c50639dd834c630a43733ffc4de3cf0736a";
    hash = "sha256-…";
  };
  elementerial-es-de = {
    url = "https://github.com/RobZombie9043/elementerial-es-de.git";
    rev = "bd77dc52b045aaa51eaaa05540d7e3a719002bbc";
    hash = "sha256-…";
  };
  epic-noir-revisited-es-de = {
    url = "https://github.com/anthonycaccese/epic-noir-revisited-es-de.git";
    rev = "0db85d77a8f4f47dbb5715d2d58493538c582dcf";
    hash = "sha256-…";
  };
  ps5-menu-es-de = {
    url = "https://github.com/InitialDin/ps5-menu-es-de.git";
    rev = "a70159ba50b700edd95a33457a8ac8409515a5d8";
    hash = "sha256-…";
  };
}
```

Initial `rev`s are taken from the existing clones in `~/ES-DE/themes/`. Hashes are filled during implementation (nix-prefetch-git or first-build mismatch).

## Integration (`home/gaming/default.nix`)

```nix
{ lib, pkgs, inputs, ... }:
let
  emulationstation-de = import ./es-de-derivation.nix { inherit pkgs; };
  themes = import ./es-de-themes.nix;
  themeFiles = lib.mapAttrs'
    (name: theme:
      lib.nameValuePair "ES-DE/themes/${name}" {
        source = pkgs.fetchgit {
          inherit (theme) url rev hash;
        };
      })
    themes;
in
{
  home.packages = [ emulationstation-de ];

  home.file = {
    "ES-DE" = {
      source = ./es-de;
      recursive = true;
    };
  } // themeFiles;

  # retroarch / xdg.configFile unchanged
}
```

### Conflict resolution

- `home.file."ES-DE" recursive` only links paths present in `./es-de` (settings). Remove `./es-de/themes/` from the tree.
- Each theme is a separate `home.file."ES-DE/themes/<name>"` pointing at a store path.
- User directories not present in `./es-de` (gamelists, scrapers, logs, …) are never touched.

## Migration (one-time, manual)

1. `rm -rf ~/ES-DE/themes/*` — remove the 5 existing clones so home-manager can create symlinks.
2. `rm -rf home/gaming/es-de/themes/` — remove untracked copies from the repo.
3. Compute and fill `hash` for each theme.
4. `./switch-home.sh`

## Error handling

| Failure | Behavior |
|---|---|
| Wrong `hash` | fetchgit build fails with nix hash-mismatch message |
| Wrong/nonexistent `rev` | fetchgit fails to resolve revision |
| Pre-existing file at `~/ES-DE/themes/<name>` | home-manager fails to create link → migrate first (step 1) |
| Theme removed from attrset | home-manager cleans orphaned links it created (`Limpando links órfãos`) |

## Verification

1. `./switch-home.sh` completes without error.
2. `ls -la ~/ES-DE/themes/` shows 4 symlinks into `/nix/store/…`.
3. `readlink ~/ES-DE/themes/ps5-menu-es-de` → store path containing `theme.xml`.
4. `grep Theme ~/ES-DE/settings/es_settings.xml` → `ps5-menu-es-de`.
5. Launch ES-DE and confirm the theme loads (manual).

## Out of scope

- Automatic rev bumps (renovate, etc.)
- Managing `themes-list` as a theme
- Managing gamelists/scrapers/etc. with Nix
- Migrating other `~/ES-DE` data into the repo
