{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.file."${config.home.homeDirectory}/Pictures/Wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${config.home.homeDirectory}/Pictures/Wallpapers/almond_blossom.jpg"
        "${config.home.homeDirectory}/Pictures/Wallpapers/forest.jpeg"
      ];

      wallpaper = [
        "DP-3,${config.home.homeDirectory}/Pictures/Wallpapers/forest.jpeg"
        "HDMI-A-1,${config.home.homeDirectory}/Pictures/Wallpapers/almond_blossom.jpg"
      ];
    };
  };
}
