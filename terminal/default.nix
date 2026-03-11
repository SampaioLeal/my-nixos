{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./ghostty.nix
    ./nushell.nix
    ./starship.nix
    ./zsh.nix
  ];
}
