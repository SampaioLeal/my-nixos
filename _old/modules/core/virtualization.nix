{ pkgs, username, ... }:
{
  # Add user to libvirtd group
  users.users.${username}.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
  ];

  # Manage the virtualisation services
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon = {
          settings = {
            features.cdi = true;
          };
        };
      };
    };
  };
}