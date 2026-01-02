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
        "${config.home.homeDirectory}/Pictures/Wallpapers/looking-skyline-city.jpg"
        "${config.home.homeDirectory}/Pictures/Wallpapers/the_starry_night.jpg"
      ];

      wallpaper = [
        "DP-3, ${config.home.homeDirectory}/Pictures/Wallpapers/looking-skyline-city.jpg"
        "HDMI-A-1, ${config.home.homeDirectory}/Pictures/Wallpapers/the_starry_night.jpg"
      ];
    };
  };
}
