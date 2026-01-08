{ inputs, pkgs, ... }:
{
  programs.ags = {
    enable = true;
    configDir = ../ags;
    extraPackages = with pkgs; [
      inputs.astal.packages.${pkgs.system}.apps
      inputs.astal.packages.${pkgs.system}.bluetooth
      inputs.astal.packages.${pkgs.system}.cava
      inputs.astal.packages.${pkgs.system}.greet
      inputs.astal.packages.${pkgs.system}.hyprland
      inputs.astal.packages.${pkgs.system}.mpris
      inputs.astal.packages.${pkgs.system}.network
      inputs.astal.packages.${pkgs.system}.notifs
      inputs.astal.packages.${pkgs.system}.tray
      inputs.astal.packages.${pkgs.system}.wireplumber
    ];
  };

  home.file."${config.xdg.configHome}/ags" = {
    force = true;
    source = ./topbar
  };
}