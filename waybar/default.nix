{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./styles.css;
  };

  home.file."${config.xdg.configHome}/waybar/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  imports = [
    ./main-bar.nix
  ];
}
