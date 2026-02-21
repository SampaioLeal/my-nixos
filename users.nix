{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.bash;

  #
  # Antonio Sampaio
  #

  users.users.sampaiol = {
    isNormalUser = true;
    description = "Antonio Sampaio";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
      "dialout"
    ];

    shell = pkgs.zsh;
  };
}
