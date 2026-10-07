{ config, pkgs, ... }:
{
  services = {
    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;

    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      settings = {
        download-dir = "${config.services.transmission.home}/Downloads";
      };
    };
  };

  systemd.services = {
    systemd-udev-settle.enable = false;
    NetworkManager-wait-online.enable = false;
    systemd-networkd-wait-online.enable = false;
    nvidia-container-toolkit-cdi-generator.enable = true;
  };
}
