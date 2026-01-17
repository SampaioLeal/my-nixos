{ pkgs, inputs, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      experimental = true;
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  environment.systemPackages = [
    inputs.compose2nix.packages.x86_64-linux.default
  ];
}
