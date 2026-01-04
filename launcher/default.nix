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
  home.file."${config.xdg.configHome}/rofi/images" = {
    source = ./images;
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

    theme = "${config.xdg.configHome}/rofi/themes/cyan-rice.rasi";
  };
}
