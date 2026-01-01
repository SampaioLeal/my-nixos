{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    libnotify
  ];
  
  imports = [
    ./dunst.nix
  ];
}
