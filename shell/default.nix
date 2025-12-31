{ lib, pkgs, inputs, ... }:
{
    imports = [
      ./kitty.nix
      ./zsh.nix
    ];
}