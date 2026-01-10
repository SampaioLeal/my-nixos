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
        "${config.home.homeDirectory}/Pictures/Wallpapers/almond_blossom.png"
        "${config.home.homeDirectory}/Pictures/Wallpapers/banks-of-the-seine-vetheuil.png"
      ];

      wallpaper = [
        "DP-3,${config.home.homeDirectory}/Pictures/Wallpapers/almond_blossom.png"
        "HDMI-A-1,${config.home.homeDirectory}/Pictures/Wallpapers/cyan-windows.png"
      ];
    };
  };
}
