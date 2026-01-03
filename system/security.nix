{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  
  security = {
    rtkit.enable = true;
    sudo.enable = true;
    polkit.enable = true;

    pam.services = {
      greetd = {
        enableGnomeKeyring = true;
      };
      swaylock = { };
      hyprlock = { };
    };
  };
}
