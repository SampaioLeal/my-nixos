{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.waybar = {
    enable = true;
  };

  imports = [
    ./main-bar.nix
    ./style.nix
  ];
}
