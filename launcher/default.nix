{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.file."${config.xdg.configHome}/rofi" = {
    source = ./configs;
  };

  programs.rofi = {
    enable = true;
    font = "FiraCode Nerd Font 12";
    location = "center";
    modes = [
      "drun"
      "emoji"
    ];
    plugins = with pkgs; [
      rofi-emoji
    ];
    terminal = "${pkgs.ghostty}/bin/ghostty";

    configPath = "${config.home.homeDirectory}/rofi/config.rasi";
  };
}
