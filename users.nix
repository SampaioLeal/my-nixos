{ pkgs, ... }:
{  
  users.defaultUserShell = pkgs.zsh;
  
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

    shell = pkgs.zsh;
  };
}
