{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.file."${config.xdg.configHome}/rofi/themes" = {
    source = ./themes;
  };

  programs.rofi = {
    enable = true;

    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
    ];
    modes = [
      "drun"
      "emoji"
      "calc"
    ];
    terminal = "${pkgs.ghostty}/bin/ghostty";

    theme = "${config.xdg.configHome}/rofi/themes/dracula.rasi";
  };
}
