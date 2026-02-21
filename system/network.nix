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
        8081
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
