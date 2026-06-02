{ pkgs, ... }:
{
  programs = {
    hyprland.enable = true;
    xwayland.enable = true;
    dconf.enable = true;
    zsh.enable = true;

    whois = {
      enable = true;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavor = "";
    };

    nix-ld = {
      enable = true;
    };
  };
}
