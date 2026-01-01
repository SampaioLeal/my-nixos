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
        "${config.home.homeDirectory}/Pictures/Wallpapers/fazendinha.jpg"
        "${config.home.homeDirectory}/Pictures/Wallpapers/almond_blossom.jpg"
      ];

      wallpaper = [
        "DP-3, ${config.home.homeDirectory}/Pictures/Wallpapers/almond_blossom.jpg"
        "HDMI-A-1, ${config.home.homeDirectory}/Pictures/Wallpapers/fazendinha.jpg"
      ];
    };
  };
}
