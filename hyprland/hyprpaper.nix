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
        "${config.home.homeDirectory}/Pictures/Wallpapers/valley-pixel-art.jpg"
        "${config.home.homeDirectory}/Pictures/Wallpapers/valley-pixel-art.jpg"
      ];

      wallpaper = [
        "DP-3,${config.home.homeDirectory}/Pictures/Wallpapers/valley-pixel-art.jpg"
        "HDMI-A-1,${config.home.homeDirectory}/Pictures/Wallpapers/valley-pixel-art.jpg"
      ];
    };
  };
}
