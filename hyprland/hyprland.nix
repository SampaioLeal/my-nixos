{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    plugins = [
      pkgs.hyprlandPlugins.hypr-dynamic-cursors
    ];
  };
}
