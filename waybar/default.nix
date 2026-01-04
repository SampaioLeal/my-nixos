{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./styles.css;
  };

  imports = [
    ./main-bar.nix
  ];
}
