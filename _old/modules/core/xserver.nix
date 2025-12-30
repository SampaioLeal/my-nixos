{ username, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "pt";
        variant = "";
      };
    };

    displayManager.autoLogin = {
      enable = false;
      user = "${username}";
    };
    libinput = {
      enable = true;
    };
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}