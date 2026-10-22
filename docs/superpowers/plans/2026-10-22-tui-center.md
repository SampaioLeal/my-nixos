# TUI Center Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir o `tui-center` em um repositório Rust independente, com launcher TUI, configuração automática, execução segura de subprocessos e integração local no flake NixOS.

**Architecture:** O app fica em `~/Documents/tui-center` e é dividido em `config.rs` (TOML), `app.rs` (estado puro), `ui.rs` (ratatui), `launcher.rs` (PATH/processo) e `main.rs` (CLI, terminal e loop). O repositório terá flake próprio; `~/my-nixos` o consome como input local `git+file:` e instala via Home Manager.

**Tech Stack:** Rust stable, ratatui 0.29, crossterm 0.28, serde, toml, clap, anyhow, unicode-normalization, tempfile, Nix flakes.

**Spec:** `/home/sampaiol/my-nixos/docs/superpowers/specs/2026-10-22-tui-center-design.md`

## Global Constraints

- Rust stable, edição 2021.
- App em `~/Documents/tui-center`, repositório Git próprio com branch `main`.
- Dependências: `anyhow = "1"`, `clap = { version = "4", features = ["derive"] }`, `crossterm = "0.28"`, `dirs = "6"`, `ratatui = "0.29"`, `serde = { version = "1", features = ["derive"] }`, `toml = "0.8"`, `unicode-normalization = "0.1"`; dev: `tempfile = "3"`.
- Todos os comandos Cargo devem rodar dentro do dev shell: `nix develop --command cargo ...`.
- O subprocesso usa `Command` com stdin/stdout/stderr herdados; nunca `sh -c`.
- Config padrão em `~/.config/tui-center/config.toml`, criada automaticamente se ausente, inclusive com `--config <PATH>` e diretórios-pai.
- Busca via `/`; `q`/`Esc` encerram apenas no modo normal; status persiste até a próxima tecla.
- Grid responsivo: `< 60` = 1 coluna, `60..=99` = 2 colunas, `>= 100` = 3 colunas.
- O input Nix em `my-nixos` é `git+file:///home/sampaiol/Documents/tui-center`; não usar caminho absoluto solto no Nix.
- Commits frequentes, um por task, em cada repositório.

## Review Focus

- Terminal muito pequeno ou textos longos/Unicode não podem causar pânico: tests de UI em 20x5 e descrição longa na Task 5.
- Executável ausente ou sem bit de execução deve abrir overlay e manter a TUI viva: tests em `launcher.rs` (Task 4) e overlay em `ui.rs` (Task 5).
- Config ausente, inválida ou impossível de criar deve gerar overlay de startup, não pânico: tests em `config.rs` (Task 2) e overlay não dispensável em `ui.rs` (Task 5).
- Filho terminando com código não zero ou sinal deve voltar à TUI com status: tests de `exit_status_message` em `launcher.rs` (Task 4).
- Lista vazia ou filtro sem resultados deve mostrar estado vazio e `Enter` não pode acessar índice inexistente: tests em `app.rs` (Task 3) e `ui.rs` (Task 5).

---

### Task 1: Bootstrap do repositório e dev shell

**Files:**
- Create: `~/Documents/tui-center/Cargo.toml`
- Create: `~/Documents/tui-center/src/main.rs`
- Create: `~/Documents/tui-center/flake.nix`
- Create: `~/Documents/tui-center/flake.lock`
- Create: `~/Documents/tui-center/.envrc`
- Create: `~/Documents/tui-center/.gitignore`

**Interfaces:**
- Consumes: nenhum.
- Produces: crate `tui-center`, `nix develop`, `Cargo.lock`; `src/main.rs` declara os módulos que as tasks seguintes criarão.

- [ ] **Step 1: Criar o repositório e o crate**

Run:
```bash
mkdir -p ~/Documents/tui-center/src
cd ~/Documents/tui-center
git init -b main
```

- [ ] **Step 2: Criar `Cargo.toml`**

```toml
[package]
name = "tui-center"
version = "0.1.0"
edition = "2021"
description = "TUI launcher for terminal applications"

[dependencies]
anyhow = "1"
clap = { version = "4", features = ["derive"] }
crossterm = "0.28"
dirs = "6"
ratatui = "0.29"
serde = { version = "1", features = ["derive"] }
toml = "0.8"
unicode-normalization = "0.1"

[dev-dependencies]
tempfile = "3"
```

- [ ] **Step 3: Criar `src/main.rs` temporário**

```rust
mod app;
mod config;
mod launcher;
mod ui;

fn main() {
    println!("tui-center");
}
```

Crie arquivos vazios `src/app.rs`, `src/config.rs`, `src/launcher.rs` e
`src/ui.rs` para o crate compilar.

- [ ] **Step 4: Criar `.gitignore` e `.envrc`**

`.gitignore`:
```gitignore
/target
/result
.direnv
*.log
```

`.envrc`:
```bash
use flake
```

- [ ] **Step 5: Criar `flake.nix` com devShell e formatter**

```nix
{
  description = "TUI launcher for terminal applications";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      eachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            cargo
            rustc
            rustfmt
            clippy
            rust-analyzer
          ];
          RUST_BACKTRACE = "1";
        };
      });

      formatter = eachSystem (pkgs: pkgs.nixfmt-rfc-style);
    };
}
```

- [ ] **Step 6: Gerar lockfiles e verificar o ambiente**

Run:
```bash
cd ~/Documents/tui-center
nix flake lock
nix develop --command cargo check
```
Expected: `cargo check` termina com `Finished`; `Cargo.lock` e `flake.lock` existem.

- [ ] **Step 7: Commit**

```bash
cd ~/Documents/tui-center
git add Cargo.toml Cargo.lock flake.nix flake.lock .envrc .gitignore src
git commit -m "chore: bootstrap Rust crate and Nix dev shell"
```

---

### Task 2: Carregamento e criação da configuração

**Files:**
- Modify: `~/Documents/tui-center/src/config.rs`

**Interfaces:**
- Consumes: dependências `serde`, `toml`, `dirs`, `anyhow`.
- Produces:
  - `pub struct Config { pub apps: Vec<AppConfig> }`
  - `pub struct AppConfig { pub name: String, pub category: String, pub description: String, pub command: String, pub args: Vec<String>, pub icon: String }`
  - `pub const EXAMPLE_CONFIG: &str`
  - `pub fn default_config_path() -> anyhow::Result<PathBuf>`
  - `pub fn load_or_create(path: &Path) -> anyhow::Result<Config>`

- [ ] **Step 1: Escrever os testes que falham em `src/config.rs`**

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use tempfile::tempdir;

    #[test]
    fn creates_example_file_and_parses_three_apps() {
        let dir = tempdir().unwrap();
        let path = dir.path().join("nested/tui-center/config.toml");

        let config = load_or_create(&path).unwrap();

        assert_eq!(fs::read_to_string(&path).unwrap(), EXAMPLE_CONFIG);
        assert_eq!(config.apps.len(), 3);
        assert_eq!(config.apps[0].name, "Atuin");
        assert_eq!(config.apps[0].args, vec!["history", "list"]);
        assert_eq!(config.apps[1].name, "Nix Tree");
        assert_eq!(config.apps[1].args, vec!["/run/current-system"]);
        assert_eq!(config.apps[2].name, "Btop");
    }

    #[test]
    fn optional_fields_use_defaults() {
        let dir = tempdir().unwrap();
        let path = dir.path().join("config.toml");
        fs::write(
            &path,
            "[[apps]]\nname = \"Tool\"\ncommand = \"tool\"\n",
        )
        .unwrap();

        let config = load_or_create(&path).unwrap();

        assert_eq!(config.apps[0].category, "");
        assert_eq!(config.apps[0].description, "");
        assert!(config.apps[0].args.is_empty());
        assert_eq!(config.apps[0].icon, "▸");
    }

    #[test]
    fn empty_file_is_valid_with_zero_apps() {
        let dir = tempdir().unwrap();
        let path = dir.path().join("config.toml");
        fs::write(&path, "").unwrap();

        let config = load_or_create(&path).unwrap();

        assert!(config.apps.is_empty());
    }

    #[test]
    fn unknown_keys_are_ignored() {
        let dir = tempdir().unwrap();
        let path = dir.path().join("config.toml");
        fs::write(
            &path,
            "extra = true\n\n[[apps]]\nname = \"Tool\"\ncommand = \"tool\"\nunknown = 1\n",
        )
        .unwrap();

        let config = load_or_create(&path).unwrap();

        assert_eq!(config.apps.len(), 1);
        assert_eq!(config.apps[0].name, "Tool");
    }

    #[test]
    fn invalid_toml_returns_error() {
        let dir = tempdir().unwrap();
        let path = dir.path().join("config.toml");
        fs::write(&path, "not = [").unwrap();

        assert!(load_or_create(&path).is_err());
    }

    #[test]
    fn missing_required_field_returns_error() {
        let dir = tempdir().unwrap();
        let path = dir.path().join("config.toml");
        fs::write(&path, "[[apps]]\nname = \"Tool\"\n").unwrap();

        assert!(load_or_create(&path).is_err());
    }

    #[test]
    fn creation_failure_is_reported_when_parent_is_a_file() {
        let dir = tempdir().unwrap();
        let parent = dir.path().join("not-a-directory");
        fs::write(&parent, "x").unwrap();
        let path = parent.join("config.toml");

        assert!(load_or_create(&path).is_err());
    }
}
```

- [ ] **Step 2: Rodar os testes e confirmar a falha**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test config::tests
```
Expected: FAIL porque `Config`, `AppConfig`, `EXAMPLE_CONFIG` e `load_or_create` ainda não existem.

- [ ] **Step 3: Implementar `src/config.rs`**

```rust
use anyhow::{Context, Result};
use serde::Deserialize;
use std::fs;
use std::path::{Path, PathBuf};

pub const DEFAULT_ICON: &str = "▸";
pub const EXAMPLE_CONFIG: &str = r#"[[apps]]
name = "Atuin"
category = "Produtividade"
description = "Histórico de comandos interativo"
command = "atuin"
args = ["history", "list"]
icon = "📜"

[[apps]]
name = "Nix Tree"
category = "NixOS"
description = "Navegador de dependências do Nix Store"
command = "nix-tree"
args = ["/run/current-system"]
icon = "❄️"

[[apps]]
name = "Btop"
category = "Sistema"
description = "Monitor de recursos e processos"
command = "btop"
icon = "📊"
"#;

#[derive(Debug, Clone, Deserialize, PartialEq, Eq)]
pub struct Config {
    #[serde(default)]
    pub apps: Vec<AppConfig>,
}

#[derive(Debug, Clone, Deserialize, PartialEq, Eq)]
pub struct AppConfig {
    pub name: String,
    #[serde(default)]
    pub category: String,
    #[serde(default)]
    pub description: String,
    pub command: String,
    #[serde(default)]
    pub args: Vec<String>,
    #[serde(default = "default_icon")]
    pub icon: String,
}

fn default_icon() -> String {
    DEFAULT_ICON.to_string()
}

pub fn default_config_path() -> Result<PathBuf> {
    let base = dirs::config_dir()
        .context("não foi possível localizar o diretório de configuração do usuário")?;
    Ok(base.join("tui-center").join("config.toml"))
}

pub fn load_or_create(path: &Path) -> Result<Config> {
    if !path.exists() {
        if let Some(parent) = path
            .parent()
            .filter(|parent| !parent.as_os_str().is_empty())
        {
            fs::create_dir_all(parent)
                .with_context(|| format!("falha ao criar diretório {}", parent.display()))?;
        }
        fs::write(path, EXAMPLE_CONFIG)
            .with_context(|| format!("falha ao criar {}", path.display()))?;
    }

    let content = fs::read_to_string(path)
        .with_context(|| format!("falha ao ler {}", path.display()))?;
    toml::from_str(&content)
        .with_context(|| format!("TOML inválido em {}", path.display()))
}
```

- [ ] **Step 4: Rodar os testes e confirmar sucesso**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test config::tests
```
Expected: PASS para os 7 testes.

- [ ] **Step 5: Commit**

```bash
cd ~/Documents/tui-center
git add src/config.rs
git commit -m "feat: load and create TOML configuration"
```

---

### Task 3: Estado, filtro, navegação e teclado

**Files:**
- Modify: `~/Documents/tui-center/src/app.rs`

**Interfaces:**
- Consumes: `crate::config::AppConfig`.
- Produces:
  - `pub enum Mode { Normal, Search }`
  - `pub struct ErrorOverlay { pub message: String, pub dismissible: bool }`
  - `pub enum Input { Char(char), Enter, Esc, Backspace, Up, Down, Left, Right, CtrlC }`
  - `pub enum Effect { None, Quit, Launch(usize) }`
  - `pub struct App` com campos públicos `apps`, `filter`, `selected`, `mode`, `columns`, `status`, `overlay`, `should_quit`
  - `App::new`, `App::with_startup_error`, `App::filtered_indices`, `App::selected_app`, `App::set_columns`, `App::handle_input`

- [ ] **Step 1: Escrever os testes que falham em `src/app.rs`**

```rust
#[cfg(test)]
mod tests {
    use super::*;

    fn app_config(name: &str, category: &str, description: &str) -> AppConfig {
        AppConfig {
            name: name.to_string(),
            category: category.to_string(),
            description: description.to_string(),
            command: "true".to_string(),
            args: vec![],
            icon: "▸".to_string(),
        }
    }

    fn sample_app() -> App {
        let apps = vec![
            app_config("Atuin", "Produtividade", "Histórico de comandos interativo"),
            app_config("Nix Tree", "NixOS", "Navegador de dependências do Nix Store"),
            app_config("Btop", "Sistema", "Monitor de recursos e processos"),
            app_config("Yazi", "Arquivos", "Gerenciador de arquivos"),
            app_config("Lazygit", "Git", "Interface para Git"),
        ];
        App::new(apps)
    }

    #[test]
    fn filters_by_name_category_and_description_case_insensitively() {
        let mut app = sample_app();

        app.handle_input(Input::Char('/'));
        for c in "NIX".chars() {
            app.handle_input(Input::Char(c));
        }
        assert_eq!(app.filtered_indices(), vec![1]);

        app.handle_input(Input::Esc);
        app.handle_input(Input::Char('/'));
        for c in "sistema".chars() {
            app.handle_input(Input::Char(c));
        }
        assert_eq!(app.filtered_indices(), vec![2]);

        app.handle_input(Input::Esc);
        app.handle_input(Input::Char('/'));
        for c in "comandos".chars() {
            app.handle_input(Input::Char(c));
        }
        assert_eq!(app.filtered_indices(), vec![0]);
    }

    #[test]
    fn filter_is_accent_insensitive() {
        let mut app = sample_app();
        app.handle_input(Input::Char('/'));
        for c in "historico".chars() {
            app.handle_input(Input::Char(c));
        }

        assert_eq!(app.filtered_indices(), vec![0]);
    }

    #[test]
    fn filter_accepts_terms_matching_different_fields() {
        let mut app = sample_app();
        app.handle_input(Input::Char('/'));
        for c in "nix navegador".chars() {
            app.handle_input(Input::Char(c));
        }

        assert_eq!(app.filtered_indices(), vec![1]);
    }

    #[test]
    fn changing_filter_resets_selection() {
        let mut app = sample_app();
        app.set_columns(3);
        app.handle_input(Input::Right);
        assert_eq!(app.selected, 1);

        app.handle_input(Input::Char('/'));
        app.handle_input(Input::Char('b'));

        assert_eq!(app.selected, 0);
        assert_eq!(app.filtered_indices(), vec![2]);
    }

    #[test]
    fn horizontal_moves_linearly_and_clamps_without_wrap() {
        let mut app = sample_app();
        app.set_columns(3);

        app.handle_input(Input::Left);
        assert_eq!(app.selected, 0);
        for _ in 0..10 {
            app.handle_input(Input::Right);
        }
        assert_eq!(app.selected, 4);
    }

    #[test]
    fn vertical_moves_by_columns_and_clamps_to_last_partial_row() {
        let mut app = sample_app();
        app.set_columns(3);

        app.handle_input(Input::Down);
        assert_eq!(app.selected, 3);
        app.handle_input(Input::Down);
        assert_eq!(app.selected, 4);
        app.handle_input(Input::Up);
        assert_eq!(app.selected, 1);
        app.handle_input(Input::Up);
        assert_eq!(app.selected, 0);
    }

    #[test]
    fn enter_with_no_results_sets_status_and_does_not_launch() {
        let mut app = sample_app();
        app.handle_input(Input::Char('/'));
        for c in "zzzz".chars() {
            app.handle_input(Input::Char(c));
        }

        let effect = app.handle_input(Input::Enter);

        assert_eq!(effect, Effect::None);
        assert!(app.status.as_deref().unwrap().contains("Nenhum app"));
    }

    #[test]
    fn q_quits_in_normal_mode_but_types_in_search_mode() {
        let mut app = sample_app();
        assert_eq!(app.handle_input(Input::Char('q')), Effect::Quit);

        let mut app = sample_app();
        app.handle_input(Input::Char('/'));
        assert_eq!(app.handle_input(Input::Char('q')), Effect::None);
        assert_eq!(app.filter, "q");
        assert_eq!(app.handle_input(Input::Esc), Effect::None);
        assert_eq!(app.mode, Mode::Normal);
        assert!(app.filter.is_empty());
    }

    #[test]
    fn normal_mode_backspace_edits_retained_filter() {
        let mut app = sample_app();
        app.filter = "atuin".to_string();

        app.handle_input(Input::Backspace);

        assert_eq!(app.filter, "atui");
        assert_eq!(app.mode, Mode::Normal);
    }

    #[test]
    fn any_key_clears_status_before_handling() {
        let mut app = sample_app();
        app.status = Some("old".to_string());

        app.handle_input(Input::Right);

        assert!(app.status.is_none());
    }

    #[test]
    fn launching_from_search_returns_to_normal_and_keeps_filter() {
        let mut app = sample_app();
        app.handle_input(Input::Char('/'));
        for c in "atuin".chars() {
            app.handle_input(Input::Char(c));
        }

        assert_eq!(app.handle_input(Input::Enter), Effect::Launch(0));
        assert_eq!(app.mode, Mode::Normal);
        assert_eq!(app.filter, "atuin");
    }

    #[test]
    fn launch_overlay_is_dismissed_with_enter_or_esc_but_not_q() {
        let mut app = sample_app();
        app.overlay = Some(ErrorOverlay {
            message: "missing".to_string(),
            dismissible: true,
        });

        assert_eq!(app.handle_input(Input::Char('q')), Effect::None);
        assert!(app.overlay.is_some());
        assert_eq!(app.handle_input(Input::Enter), Effect::None);
        assert!(app.overlay.is_none());
    }

    #[test]
    fn startup_overlay_only_allows_quitting() {
        let mut app = App::with_startup_error(vec![], "bad config".to_string());

        assert_eq!(app.handle_input(Input::Enter), Effect::None);
        assert!(app.overlay.is_some());
        assert_eq!(app.handle_input(Input::Char('q')), Effect::Quit);
    }

    #[test]
    fn ctrl_c_quits_even_with_overlay() {
        let mut app = App::with_startup_error(vec![], "bad config".to_string());
        assert_eq!(app.handle_input(Input::CtrlC), Effect::Quit);
    }
}
```

- [ ] **Step 2: Rodar os testes e confirmar a falha**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test app::tests
```
Expected: FAIL porque `App`, `Input` e `Effect` ainda não existem.

- [ ] **Step 3: Implementar `src/app.rs`**

Implemente exatamente as interfaces do bloco **Interfaces**. Regras:

- `App::new` inicia em `Mode::Normal`, `selected = 0`, `columns = 1`.
- `App::with_startup_error` cria um `ErrorOverlay` com `dismissible: false`.
- `handle_input` trata `CtrlC` primeiro e sempre define `should_quit = true` e
  retorna `Effect::Quit`.
- Todo caminho que retorna `Effect::Quit` também define `should_quit = true`.
- Com overlay não dispensável: apenas `q`/`Esc` retornam `Quit`; o resto é `None`.
- Com overlay dispensável: `Enter`/`Esc` limpam o overlay; `q` é ignorado.
- `handle_input` limpa `status` antes de processar uma tecla normal.
- `Char('/')` no modo normal entra em `Search`.
- No modo normal: `q`/`Esc` saem; `j`/`Down` e `k`/`Up` movem `columns`; `h`/`Left` e `l`/`Right` movem 1; `Backspace` remove do filtro; `Enter` executa.
- No modo busca: `Char(c)` adiciona; `Backspace` remove; `Esc` limpa o filtro e volta a `Normal`; `Enter` executa; `Up`/`Down` navegam.
- `filtered_indices` normaliza com NFD (`UnicodeNormalization` + `is_combining_mark`), converte para minúsculas e aplica AND entre termos e OR entre `name`/`category`/`description`.
- `selected_app` usa `filtered_indices().get(self.selected)`.
- `set_columns` força no mínimo 1.
- `Launch(i)` usa o índice real em `apps`, não o índice filtrado.
- `Enter` sem resultados define `status = Some("Nenhum app selecionado".into())`.

- [ ] **Step 4: Rodar os testes e confirmar sucesso**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test app::tests
```
Expected: PASS para os 14 testes.

- [ ] **Step 5: Commit**

```bash
cd ~/Documents/tui-center
git add src/app.rs
git commit -m "feat: add app state, filtering and keyboard navigation"
```

---

### Task 4: Resolução de executáveis e execução

**Files:**
- Modify: `~/Documents/tui-center/src/launcher.rs`

**Interfaces:**
- Consumes: `crate::config::AppConfig` apenas indiretamente; a API recebe comando/args.
- Produces:
  - `pub enum ExecutableError { NotFound { command: String }, NotExecutable { path: PathBuf } }`
  - `pub fn resolve_executable(command: &str) -> Result<PathBuf, ExecutableError>`
  - `pub fn spawn_and_wait(executable: &Path, args: &[String]) -> std::io::Result<ExitStatus>`
  - `pub fn exit_status_message(name: &str, status: ExitStatus) -> Option<String>`
  - `fn resolve_with_path(command: &str, path_var: Option<&OsStr>) -> Result<PathBuf, ExecutableError>` (privada, testável no módulo)

- [ ] **Step 1: Escrever os testes que falham em `src/launcher.rs`**

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use std::path::Path;
    use tempfile::tempdir;

    #[cfg(unix)]
    fn make_executable(path: &Path) {
        use std::os::unix::fs::PermissionsExt;
        let mut permissions = fs::metadata(path).unwrap().permissions();
        permissions.set_mode(0o755);
        fs::set_permissions(path, permissions).unwrap();
    }

    #[test]
    fn finds_command_in_supplied_path() {
        let dir = tempdir().unwrap();
        let tool = dir.path().join("mytool");
        fs::write(&tool, "#!/bin/sh\n").unwrap();
        #[cfg(unix)]
        make_executable(&tool);

        let found = resolve_with_path("mytool", Some(dir.path().as_os_str())).unwrap();

        assert_eq!(found, tool);
    }

    #[test]
    fn returns_not_found_for_missing_command() {
        let dir = tempdir().unwrap();
        let error = resolve_with_path("missing-tool", Some(dir.path().as_os_str())).unwrap_err();
        assert_eq!(
            error,
            ExecutableError::NotFound {
                command: "missing-tool".to_string()
            }
        );
    }

    #[test]
    fn accepts_absolute_path_with_slash() {
        let dir = tempdir().unwrap();
        let tool = dir.path().join("mytool");
        fs::write(&tool, "#!/bin/sh\n").unwrap();
        #[cfg(unix)]
        make_executable(&tool);

        let found = resolve_with_path(tool.to_str().unwrap(), None).unwrap();

        assert_eq!(found, tool);
    }

    #[cfg(unix)]
    #[test]
    fn rejects_file_without_execute_bit() {
        let dir = tempdir().unwrap();
        let tool = dir.path().join("mytool");
        fs::write(&tool, "#!/bin/sh\n").unwrap();

        let error = resolve_with_path(tool.to_str().unwrap(), None).unwrap_err();

        assert_eq!(error, ExecutableError::NotExecutable { path: tool });
    }

    #[cfg(unix)]
    #[test]
    fn spawns_and_waits_for_child() {
        let status = spawn_and_wait(
            Path::new("sh"),
            &["-c".to_string(), "exit 7".to_string()],
        )
        .unwrap();

        assert_eq!(status.code(), Some(7));
    }

    #[test]
    fn spawn_error_is_returned() {
        let result = spawn_and_wait(Path::new("/definitely/not/a/real-binary"), &[]);
        assert!(result.is_err());
    }

    #[test]
    fn success_has_no_status_message() {
        let status = spawn_and_wait(
            Path::new("sh"),
            &["-c".to_string(), "exit 0".to_string()],
        )
        .unwrap();

        assert_eq!(exit_status_message("Tool", status), None);
    }

    #[cfg(unix)]
    #[test]
    fn non_zero_and_signal_statuses_have_messages() {
        use std::os::unix::process::ExitStatusExt;

        let code = ExitStatus::from_raw(7 << 8);
        assert_eq!(
            exit_status_message("Tool", code),
            Some("Tool saiu com código 7".to_string())
        );

        let signal = ExitStatus::from_raw(9);
        assert_eq!(
            exit_status_message("Tool", signal),
            Some("Tool foi encerrado por um sinal".to_string())
        );
    }
}
```

- [ ] **Step 2: Rodar os testes e confirmar a falha**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test launcher::tests
```
Expected: FAIL porque as funções e o enum ainda não existem.

- [ ] **Step 3: Implementar `src/launcher.rs`**

Regras:

- `command` vazio → `NotFound`.
- Se `command` contém `/`, use `PathBuf::from(command)`: caminho executável → `Ok`; existe mas sem permissão → `NotExecutable`; não existe → `NotFound`.
- Sem `/`, percorra `std::env::split_paths(path_var)` na ordem e retorne o primeiro arquivo executável.
- Em Unix, executável significa `is_file()` e `mode & 0o111 != 0`.
- `spawn_and_wait` usa `Command::new(executable).args(args)`, com `.stdin(Stdio::inherit())`, `.stdout(Stdio::inherit())`, `.stderr(Stdio::inherit())` e `.status()`.
- `exit_status_message` retorna `None` em sucesso, `"<nome> saiu com código <n>"` para código não zero e `"<nome> foi encerrado por um sinal"` quando não há código.
- `ExecutableError` deriva `Debug`, `PartialEq` e `Eq`, e implementa `Display` e `std::error::Error`.
- Mensagens de erro em português, por exemplo `"comando 'x' não encontrado no PATH"` e `"o arquivo 'y' não é executável"`.

- [ ] **Step 4: Rodar os testes e confirmar sucesso**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test launcher::tests
```
Expected: PASS para os 8 testes relevantes à plataforma.

- [ ] **Step 5: Commit**

```bash
cd ~/Documents/tui-center
git add src/launcher.rs
git commit -m "feat: resolve executables and run child processes"
```

---

### Task 5: Renderização da TUI

**Files:**
- Modify: `~/Documents/tui-center/src/ui.rs`

**Interfaces:**
- Consumes: `crate::app::App`, `ratatui`.
- Produces:
  - `pub fn grid_columns(width: u16) -> usize`
  - `pub fn draw(frame: &mut ratatui::Frame, app: &App)`

- [ ] **Step 1: Escrever os testes que falham em `src/ui.rs`**

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use crate::app::{App, ErrorOverlay, Mode};
    use crate::config::AppConfig;
    use ratatui::backend::TestBackend;
    use ratatui::Terminal;

    fn app_config(name: &str, description: &str) -> AppConfig {
        AppConfig {
            name: name.to_string(),
            category: "Categoria".to_string(),
            description: description.to_string(),
            command: "true".to_string(),
            args: vec![],
            icon: "📜".to_string(),
        }
    }

    fn sample_app() -> App {
        let mut app = App::new(vec![
            app_config("Atuin", "Histórico de comandos"),
            app_config("Btop", "Monitor de recursos"),
            app_config("Yazi", "Gerenciador de arquivos"),
        ]);
        app.set_columns(3);
        app
    }

    fn render(app: &App, width: u16, height: u16) -> Terminal<TestBackend> {
        let backend = TestBackend::new(width, height);
        let mut terminal = Terminal::new(backend).unwrap();
        terminal.draw(|frame| draw(frame, app)).unwrap();
        terminal
    }

    fn text(terminal: &Terminal<TestBackend>) -> String {
        let buffer = terminal.backend().buffer();
        let area = buffer.area;
        let mut output = String::new();
        for y in 0..area.height {
            for x in 0..area.width {
                output.push_str(buffer.get(x, y).symbol());
            }
            output.push('\n');
        }
        output
    }

    #[test]
    fn columns_follow_width_thresholds() {
        assert_eq!(grid_columns(20), 1);
        assert_eq!(grid_columns(59), 1);
        assert_eq!(grid_columns(60), 2);
        assert_eq!(grid_columns(99), 2);
        assert_eq!(grid_columns(100), 3);
    }

    #[test]
    fn renders_header_help_and_app_names() {
        let app = sample_app();
        let terminal = render(&app, 120, 30);
        let output = text(&terminal);

        assert!(output.contains("TUI Center"));
        assert!(output.contains("Atuin"));
        assert!(output.contains("Btop"));
        assert!(output.contains("Enter"));
    }

    #[test]
    fn renders_empty_state_when_filter_matches_nothing() {
        let mut app = sample_app();
        app.filter = "zzzz".to_string();
        let terminal = render(&app, 80, 24);

        assert!(text(&terminal).contains("Nenhum app encontrado"));
    }

    #[test]
    fn renders_search_cursor_and_status() {
        let mut app = sample_app();
        app.mode = Mode::Search;
        app.filter = "nix".to_string();
        app.status = Some("status visível".to_string());
        let terminal = render(&app, 80, 24);
        let output = text(&terminal);

        assert!(output.contains("Busca: nix_"));
        assert!(output.contains("status visível"));
    }

    #[test]
    fn renders_dismissible_error_overlay() {
        let mut app = sample_app();
        app.overlay = Some(ErrorOverlay {
            message: "comando não encontrado".to_string(),
            dismissible: true,
        });
        let terminal = render(&app, 80, 24);
        let output = text(&terminal);

        assert!(output.contains("Erro ao executar"));
        assert!(output.contains("comando não encontrado"));
        assert!(output.contains("Enter/Esc"));
    }

    #[test]
    fn renders_non_dismissible_startup_error() {
        let app = App::with_startup_error(vec![], "TOML inválido".to_string());
        let terminal = render(&app, 80, 24);
        let output = text(&terminal);

        assert!(output.contains("Erro na configuração"));
        assert!(output.contains("TOML inválido"));
        assert!(output.contains("q/Esc"));
    }

    #[test]
    fn tiny_terminal_and_long_text_do_not_panic() {
        let mut app = App::new(vec![app_config("Longo", &"x".repeat(400))]);
        app.set_columns(1);

        let _ = render(&app, 20, 5);
        let _ = render(&app, 10, 3);

        let startup = App::with_startup_error(vec![], "erro".to_string());
        let _ = render(&startup, 10, 3);
    }
}
```

- [ ] **Step 2: Rodar os testes e confirmar a falha**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test ui::tests
```
Expected: FAIL porque `draw` e `grid_columns` ainda não existem.

- [ ] **Step 3: Implementar `src/ui.rs`**

Layout e regras:

- `Layout` vertical: header `Length(3)`, body `Min(1)`, status `Length(1)`.
- Header, em três linhas: `TUI Center` + contagem; linha de busca; ajuda de teclas com `j/k/h/l`, `Enter`, `/` e `q/Esc`.
- Modo busca: `"Busca: {filter}_"`.
- Modo normal com filtro: `"Filtro: {filter} (Backspace limpa, / edita)"`.
- Modo normal sem filtro: `"Busca: pressione / para filtrar"`.
- Status: `app.status` se existir; senão use `app.selected_app()` para mostrar
  `"<n> resultado(s) | <nome selecionado> | Enter: executar"`; sem seleção,
  `"<n> resultado(s) | Enter: executar"`.
- Body: grid com altura fixa de 5 linhas por card, scroll vertical para manter o selecionado visível, sem wrap-around. Quando o body tiver menos de 5 linhas, limite a altura do card ao espaço disponível para não desenhar fora da área.
- Card selecionado com borda de destaque; mostrar ícone, nome, categoria e descrição truncada.
- Sem resultados: `"Nenhum app encontrado"` centralizado.
- Overlay:
  - dispensável: título `Erro ao executar`, dica `[Enter/Esc] Fechar`;
  - startup: título `Erro na configuração`, dica `[q/Esc] Sair`.
- Use `Clear` antes do overlay.
- Larguras e alturas pequenas não podem causar pânico (teste 20x5 e 10x3).
- `grid_columns`: `< 60` → 1, `< 100` → 2, senão 3.

- [ ] **Step 4: Rodar os testes e confirmar sucesso**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test ui::tests
```
Expected: PASS para os 7 testes.

- [ ] **Step 5: Commit**

```bash
cd ~/Documents/tui-center
git add src/ui.rs
git commit -m "feat: render responsive card grid and overlays"
```

---

### Task 6: CLI, terminal e ciclo de execução

**Files:**
- Modify: `~/Documents/tui-center/src/main.rs`

**Interfaces:**
- Consumes: todas as APIs das Tasks 2–5.
- Produces: binário `tui-center` funcional, com `--config <PATH>`, loop de eventos e restauração do terminal.

- [ ] **Step 1: Escrever testes de mapeamento de teclas em `src/main.rs`**

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use crossterm::event::{KeyCode, KeyEvent, KeyModifiers};

    #[test]
    fn maps_ctrl_c_before_plain_characters() {
        let key = KeyEvent::new(KeyCode::Char('c'), KeyModifiers::CONTROL);
        assert_eq!(map_key(key), Some(Input::CtrlC));
    }

    #[test]
    fn maps_navigation_and_text_keys() {
        assert_eq!(
            map_key(KeyEvent::new(KeyCode::Char('j'), KeyModifiers::NONE)),
            Some(Input::Char('j'))
        );
        assert_eq!(
            map_key(KeyEvent::new(KeyCode::Up, KeyModifiers::NONE)),
            Some(Input::Up)
        );
        assert_eq!(
            map_key(KeyEvent::new(KeyCode::Enter, KeyModifiers::NONE)),
            Some(Input::Enter)
        );
        assert_eq!(
            map_key(KeyEvent::new(KeyCode::Backspace, KeyModifiers::NONE)),
            Some(Input::Backspace)
        );
    }

    #[test]
    fn ignores_unhandled_keys() {
        assert_eq!(
            map_key(KeyEvent::new(KeyCode::F(5), KeyModifiers::NONE)),
            None
        );
    }
}
```

- [ ] **Step 2: Rodar os testes e confirmar a falha**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test main::tests
```
Expected: FAIL porque `map_key` ainda não existe.

- [ ] **Step 3: Implementar `src/main.rs`**

Responsabilidades:

- `#[derive(Parser)]` com `#[command(version, about = "...")]` e `#[arg(long)] config: Option<PathBuf>`.
- Instalar panic hook que executa `disable_raw_mode` e
  `execute!(stdout(), LeaveAlternateScreen, Show)` antes do hook padrão.
- Carregar config:
  - `--config` → `load_or_create(path)`;
  - sem flag → `default_config_path()` e depois `load_or_create`;
  - em erro, `App::with_startup_error(Vec::new(), format!("{error:#}"))`.
- `TerminalSession` com:
  - `new()`: `enable_raw_mode`, `EnterAlternateScreen`, `Hide`, `Terminal::new(CrosstermBackend::new(stdout()))`;
  - `suspend()`: `disable_raw_mode`, `LeaveAlternateScreen`, `Show`, `show_cursor`, `clear`, `active = false`;
  - `resume()`: `enable_raw_mode`, `EnterAlternateScreen`, `Hide`, `clear`, `active = true`;
  - `Drop`: se `active`, restaurar sem mascarar o erro original.
- Loop:
  - antes de desenhar, `terminal.size()`, `app.set_columns(ui::grid_columns(width))`;
  - `terminal.draw(|frame| ui::draw(frame, &app))`;
  - `event::read()`;
  - `Event::Resize` apenas continua (o próximo loop recalcula);
  - `Event::Key` com `KeyEventKind::Release` é ignorado;
  - `map_key` mapeia `Ctrl+C`, chars, Enter, Esc, Backspace e setas;
  - `Effect::Quit` encerra; `Effect::Launch(i)` executa; `app.should_quit` também
    encerra o loop (defesa contra saída sinalizada pelo estado).
- Execução:
  1. obter/clonar `app.apps.get(i)`; se o índice não existir, ignorar o efeito;
  2. `resolve_executable` antes de suspender;
  3. erro → `overlay = Some(ErrorOverlay { dismissible: true, ... })`;
  4. sucesso → `session.suspend()`, `spawn_and_wait`, `session.resume()`;
  5. erro de spawn → overlay dispensável com o erro;
  6. status do filho → `app.status = exit_status_message(...)`.
- `map_key` ignora `KeyEventKind::Release` fora da função; a função mapeia apenas
  `KeyCode`.
- Após `resume`, recalcular colunas no próximo loop.

- [ ] **Step 4: Rodar os testes e confirmar sucesso**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo test
```
Expected: PASS em todos os testes; `cargo build` compila o binário.

- [ ] **Step 5: Verificação não interativa**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo run -- --help
```
Expected: help mostra `Usage: tui-center [OPTIONS]`, `--config <CONFIG>` e `--version`.

- [ ] **Step 6: Commit**

```bash
cd ~/Documents/tui-center
git add src/main.rs
git commit -m "feat: wire terminal lifecycle, CLI and app execution"
```

---

### Task 7: Empacotamento Nix e README

**Files:**
- Create: `~/Documents/tui-center/package.nix`
- Modify: `~/Documents/tui-center/flake.nix`
- Modify: `~/Documents/tui-center/README.md`

**Interfaces:**
- Consumes: crate, `Cargo.lock`, `flake.nix`.
- Produces: `packages.default`, `apps.default`, `nix build`, `nix run`, documentação de uso.

- [ ] **Step 1: Criar `package.nix`**

```nix
{
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "tui-center";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./src
      ./README.md
    ];
  };

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    description = "TUI launcher for terminal applications";
    mainProgram = "tui-center";
    platforms = lib.platforms.linux;
  };
}
```

- [ ] **Step 2: Adicionar outputs ao `flake.nix`**

Dentro do `let`, adicione `eachSystem`. Nos outputs, adicione:

```nix
packages = eachSystem (pkgs: rec {
  default = pkgs.callPackage ./package.nix { };
  tui-center = default;
});

apps = eachSystem (pkgs: {
  default = {
    type = "app";
    program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/tui-center";
  };
});
```

Mantenha `devShells` e `formatter`.

- [ ] **Step 3: Criar `README.md` em português**

Inclua, no mínimo:

- descrição e funcionalidades;
- `nix develop`, `cargo run`, `cargo test`, `cargo fmt --check`, `cargo clippy -- -D warnings`;
- `nix build` e `nix run`;
- configuração em `~/.config/tui-center/config.toml` e criação automática;
- exemplo completo de TOML com os três apps;
- atalhos (`j/k/h/l`, setas, `/`, Enter, Backspace, `q`/Esc, Ctrl+C);
- explicação do retorno ao alternate screen após o subprocesso;
- aviso de que `--config` também cria o arquivo se ele não existir;
- integração em `my-nixos` como input local e o comando `nix flake update tui-center`;
- solução de problemas para comando ausente do `PATH`.

- [ ] **Step 4: Validar o pacote**

Run:
```bash
cd ~/Documents/tui-center
nix build
./result/bin/tui-center --help
nix run . -- --help
```
Expected: build sem erro, dois `--help` mostrando as opções.

- [ ] **Step 5: Commit**

```bash
cd ~/Documents/tui-center
git add package.nix flake.nix README.md
git commit -m "feat: package tui-center with Nix and document usage"
```

---

### Task 8: Integração no flake NixOS e Home Manager

**Files:**
- Modify: `/home/sampaiol/my-nixos/flake.nix`
- Modify: `/home/sampaiol/my-nixos/flake.lock`
- Create: `/home/sampaiol/my-nixos/home/packages/tui-center.nix`
- Modify: `/home/sampaiol/my-nixos/home/default.nix`
- Include: `docs/superpowers/specs/2026-10-22-tui-center-design.md`
- Include: `docs/superpowers/plans/2026-10-22-tui-center.md`

**Interfaces:**
- Consumes: flake com `packages.default` em `~/Documents/tui-center`.
- Produces: pacote instalado no Home Manager via `inputs.tui-center`.

- [ ] **Step 1: Adicionar o input em `flake.nix`**

No bloco `inputs`:

```nix
tui-center = {
  url = "git+file:///home/sampaiol/Documents/tui-center";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

- [ ] **Step 2: Criar `home/packages/tui-center.nix`**

```nix
{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.tui-center.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```

- [ ] **Step 3: Importar o módulo em `home/default.nix`**

Adicione `./packages/tui-center.nix` à lista `imports`, ao lado dos outros
pacotes.

- [ ] **Step 4: Atualizar o lock do input**

O input `git+file:` enxerga apenas commits. Confirme que o repositório do app
está limpo e com o commit da Task 7 antes de travar.

Run:
```bash
cd /home/sampaiol/my-nixos
nix flake update tui-center
```
Expected: `flake.lock` ganha o nó `tui-center`; outros inputs não são atualizados.

- [ ] **Step 5: Verificar a avaliação do Home Manager**

Run:
```bash
cd /home/sampaiol/my-nixos
nix eval .#homeConfigurations.sampaiol.activationPackage.drvPath --raw
```
Expected: imprime um caminho `/nix/store/...drv` sem erro de avaliação.

- [ ] **Step 6: Commit**

```bash
cd /home/sampaiol/my-nixos
git add flake.nix flake.lock home/default.nix home/packages/tui-center.nix \
  docs/superpowers/specs/2026-10-22-tui-center-design.md \
  docs/superpowers/plans/2026-10-22-tui-center.md
git commit -m "feat: integrate tui-center as local flake input"
```

---

### Task 9: Verificação final

**Files:**
- Nenhum arquivo novo; corrigir apenas falhas encontradas.

**Interfaces:**
- Consumes: tudo.
- Produces: evidência de build, testes e integração.

- [ ] **Step 1: Rodar formatação, lint e testes**

Run:
```bash
cd ~/Documents/tui-center
nix develop --command cargo fmt --check
nix develop --command cargo clippy -- -D warnings
nix develop --command cargo test
```
Expected: todos os comandos terminam com código 0; todos os testes passam.

- [ ] **Step 2: Rebuild do pacote e smoke test do CLI**

Run:
```bash
cd ~/Documents/tui-center
nix build
./result/bin/tui-center --version
./result/bin/tui-center --help
```
Expected: versão `0.1.0` e help com `--config`.

- [ ] **Step 3: Verificar a integração NixOS**

Run:
```bash
cd /home/sampaiol/my-nixos
nix eval .#homeConfigurations.sampaiol.activationPackage.drvPath --raw
```
Expected: caminho de derivação válido.

- [ ] **Step 4: Smoke test interativo**

Em um terminal real, rode com config temporária:

```bash
cd ~/Documents/tui-center
nix develop --command cargo run -- --config /tmp/tui-center-smoke/config.toml
```

Confirme:

- o arquivo de config é criado;
- `j`/`k`/`h`/`l` e setas navegam;
- `/` filtra e `Esc` limpa;
- `Enter` em um comando inexistente mostra o overlay e a TUI continua;
- executar `Btop` (se instalado) retorna ao `tui-center`;
- `q`/`Esc` restauram o terminal.

- [ ] **Step 5: Estado final dos repositórios**

Run:
```bash
cd ~/Documents/tui-center && git status --short
cd /home/sampaiol/my-nixos && git status --short
```
Expected: sem arquivos não commitados.

- [ ] **Step 6: Commit de correções, se houver**

```bash
cd ~/Documents/tui-center
git add -A
git commit -m "chore: final verification fixes"

cd /home/sampaiol/my-nixos
git add -A
git commit -m "chore: final tui-center integration fixes"
```

Se um dos repositórios não tiver mudanças, não crie commit vazio nele.
