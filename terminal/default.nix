{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./ghostty.nix
    ./starship.nix
    ./zsh.nix
  ];
}
