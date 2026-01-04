{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.rofi = {
    enable = true;
  };

  imports = [
    ./settings.nix
  ];
}
