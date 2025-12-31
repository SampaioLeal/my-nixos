{ pkgs, ... }:
{  
  #
  # Antonio Sampaio
  #
  
  users.users.sampaiol = {
    isNormalUser = true;
    description = "Antonio Sampaio";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [];
  };
}
