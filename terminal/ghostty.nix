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
      background-opacity = 0.85;
      background-blur = 40;
      background = "#000000";

      confirm-close-surface = false;
    };
    themes = { };
  };
}
