{ ... }:
{
  boot.loader = {
    systemd-boot.enable = false;

    timeout = 5;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;

      configurationLimit = 5;
      splashImage = null;

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

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = false;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "8250.nr_uarts=0"
    "nvme_core.default_ps_max_latency_us=0"
  ];
  boot.extraModprobeConfig = ''
    options rtw88_core disable_lps_deep=y
  '';

  systemd.settings.Manager = {
    DefaultIOAccounting = true;
    DefaultIPAccounting = true;
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "5s";
  };

  systemd.units."dev-tpmrm0.device".enable = false;
  systemd.tpm2.enable = false;
}
