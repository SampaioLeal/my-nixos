{ lib, pkgs, inputs, ... }:
{
    imports = [
      ./ghostty.nix
      ./kitty.nix
      ./zsh.nix
    ];
}