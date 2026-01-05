{ pkgs, ... }:
{
  networking = {
    hostName = "workstation";

    networkmanager.enable = true;

    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        7777
        8888
      ];
      allowedUDPPorts = [
        7777
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Network and Bluetooth
    networkmanager
    aria2
  ];
}
