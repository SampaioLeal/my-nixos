{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = ../ags;
    systemd.enable = true;
    extraPackages = with pkgs; [
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.apps
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.bluetooth
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.cava
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.greet
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.mpris
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.network
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.notifd
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.tray
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.wireplumber
      
      libadwaita
    ];
  };
}
