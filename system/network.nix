{ pkgs, ... }:
{
  networking = {
    hostName = "workstation";

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "8.8.4.4"
    ];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        8081
        3000
      ];
      allowedUDPPorts = [
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Network and Bluetooth
    networkmanager
    aria2
  ];
}
