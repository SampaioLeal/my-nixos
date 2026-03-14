{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    spotify
  ];

  imports = [
    ./tui.nix
  ];
}
