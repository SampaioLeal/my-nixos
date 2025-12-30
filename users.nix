{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;

  users.users.sampaiol = {
    isNormalUser = true;
    description = "Antonio Sampaio";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      wofi
      waybar
      kitty
      zathura
      cliphist
      dunst
      jq
      fastfetch
    ];
  };
}