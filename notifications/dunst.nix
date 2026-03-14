{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.dunst = {
    enable = false;
    settings = {};
  };
}
