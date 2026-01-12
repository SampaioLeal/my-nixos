{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
      };
    };
  };
}
