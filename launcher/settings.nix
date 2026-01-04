{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.rofi.settings = {
    font = "FiraCode Nerd Font";
    location = "center";
    modes = [
      "drun"
      "emoji"
    ];
    plugins = [];
    terminal = "${pkgs.ghostty}/bin/ghostty";
    theme = builtins.readFile ./styles.css;
  };
}
