{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    adwaita-icon-theme
    qt6.qtdeclarative
  ];
  programs.quickshell = {
    enable = true;
  };
}
