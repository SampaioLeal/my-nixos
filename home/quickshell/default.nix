{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.serpantinum.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    qt6.qtdeclarative
  ];

  programs.quickshell = {
    enable = true;
  };

  programs.serpantinum = {
    enable = true;
    systemd.enable = true;

    settings = {
      wallpaperDir = "/home/sampaiol/Pictures/Wallpapers";

      general = {
        language = "pt";
        weatherUnit = "metric";
        weatherInterval = 30;
      };

      bar = {
        position = "top";
        style = "fill";
        #   width = 40;
        #   workspaceCount = 10;
        #   modules = {
        #     left = [ "workspaces" ];
        #     center = [ "time" ];
        #     right = [
        #       "tray"
        #       [
        #         "kb"
        #         "wifi"
        #         "bt"
        #         "vol"
        #         "bat"
        #       ]
        #     ];
        #   };
      };

      # theme = {
      #   fontFamily = "Adwaita Mono";
      #   borderRadius = 12;
      #   matugen = true;
      # };

      idle = {
        "enabled" = false;
      };

      # notifications = {
      #   dnd = false;
      #   position = "top right";
      #   sound = true;
      # };
    };
  };
}
