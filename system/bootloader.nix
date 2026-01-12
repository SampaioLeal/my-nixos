{ config, pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = false;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      extraEntries = ''
        menuentry "Reboot" {
            reboot
        }
        menuentry "Power off" {
            halt
        }
      '';
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];
}
