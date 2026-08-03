{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprshot.nix
    ./hyprsunset.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    configType = "lua";

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    systemd.variables = [ "--all" ];
  };

  xdg.configFile."hypr/hyprland.lua".source = pkgs.replaceVarsWith {
    src = ./lua/hyprland.lua;
    replacements = {
      dynamicCursors = "${pkgs.hyprlandPlugins.hypr-dynamic-cursors}";
      polkitGnome = "${pkgs.polkit_gnome}";
      DEFAULT_AUDIO_SINK = null;
      DEFAULT_AUDIO_SOURCE = null;
    };
  };
}
