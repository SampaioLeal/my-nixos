{
  lib,
  config,
  pkgs,
  ...
}: let
  userName = "sampaiol";
  userDescription = "Antonio Sampaio";
in {
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "docker" "wireshark" "libvirtd" "kvm"];
    };
    programs.zsh.enable = true;
  };
}
