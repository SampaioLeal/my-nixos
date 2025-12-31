{ lib, pkgs, inputs, ... }:
{
    programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
    };
}