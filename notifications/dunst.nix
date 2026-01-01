{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.dunst = {
    enable = true;
    settings = {};
  };
}
