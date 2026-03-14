{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./autostart.nix
    ./hyprpaper.nix
    ./settings.nix
    ./window-rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = null;
    portalPackage = null;

    plugins = [
      # pkgs.hyprlandPlugins.hypr-dynamic-cursors
    ];

    systemd.variables = [ "--all" ];
  };
}
