{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.wofi.settings = {
    mode = "drun,run";
    width = "50%";
    height = "40%";
    term = "ghostty";
  };
}
