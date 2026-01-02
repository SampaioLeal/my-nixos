{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];

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
