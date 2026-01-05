{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./settings.nix
    ./window-rules.nix
  ];
}
