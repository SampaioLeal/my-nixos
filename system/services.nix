{ pkgs, ... }:
{
  services = {
    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;
  };
}
