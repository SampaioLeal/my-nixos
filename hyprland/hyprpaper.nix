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
        "${config.home.homeDirectory}/Pictures/Wallpapers/cyan-windows.png"
      ];

      wallpaper = [
        "DP-3,${config.home.homeDirectory}/Pictures/Wallpapers/cyan-windows.png"
        "HDMI-A-1,${config.home.homeDirectory}/Pictures/Wallpapers/cyan-windows.png"
      ];
    };
  };
}
