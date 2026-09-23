{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  emulationstation-de = import ./es-de-derivation.nix { inherit pkgs; };
  themes = import ./es-de-themes.nix;
  themeFiles = lib.mapAttrs' (
    name: theme:
    lib.nameValuePair "ES-DE/themes/${name}" {
      source = pkgs.fetchgit {
        inherit (theme) url rev hash;
      };
    }
  ) themes;
in
{
  home.packages = [
    emulationstation-de
  ];

  home.file = {
    "ES-DE" = {
      source = ./es-de;
      recursive = true;
    };
  }
  // themeFiles;

  programs.retroarch = {
    enable = true;
    cores = {
      snes9x = {
        enable = true;
        package = pkgs.libretro.snes9x;
      };
      pcsx2 = {
        enable = true;
        package = pkgs.libretro.pcsx2;
      };
    };
    settings = {
      # See https://github.com/libretro/RetroArch/blob/master/retroarch.cfg for available configuration options.
      video_driver = "vulkan";
      video_fullscreen = "true";
      # input_max_users = "4";
      # menu_scale_factor = "0.950000";
      # netplay_nickname = "username";
    };
  };

  xdg.configFile."retroarch" = {
    source = ./retroarch;
    recursive = true;
  };
}
