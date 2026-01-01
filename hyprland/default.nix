{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./settings.nix
  ];
}
