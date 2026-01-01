{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.wofi = {
    enable = true;
  };
  
  imports = [
    ./settings.nix
    ./style.nix
  ];
}
