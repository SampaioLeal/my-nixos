{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "pt";
        variant = "";
      };
    };

    displayManager.autoLogin.enable = false;
    libinput.enable = true;
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}