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

    nh = {
      enable = true;
      # clean.enable fica desligado: nix.gc.automatic já roda weekly.
      # Use `nh clean all` manualmente (collect-garbage.sh).
      clean.enable = false;
      flake = "/home/sampaiol/my-nixos";
    };
  };
}
