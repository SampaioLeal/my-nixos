{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Abernathy";
      font-size = 12;
      font-family = "FiraCode Nerd Font Mono";
      font-family-bold = "FiraCode Nerd Font Mono Bold";
      background = "#000000";
      background-opacity = 0.50;
      background-blur = 40;

      confirm-close-surface = false;
    };
    themes = { };
  };
}
