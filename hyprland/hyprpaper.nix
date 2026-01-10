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
      wallpaper = [
        {
          monitor = "DP-3";
          path = "${config.home.homeDirectory}/Pictures/Wallpapers/almond-blossom.png";
          # path = "${config.home.homeDirectory}/Pictures/Wallpapers/forest.jpeg";
          fit_mode = "cover";
        }
        {
          monitor = "HDMI-A-1";
          path = "${config.home.homeDirectory}/Pictures/Wallpapers/almond-blossom.png";
          fit_mode = "cover";
        }
      ];
    };
  };
}
