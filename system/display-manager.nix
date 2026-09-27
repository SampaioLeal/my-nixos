{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.sysc-greet.nixosModules.default
  ];

  services.logind.settings.Login.HandlePowerKey = "suspend";

  # sysc-greet gerencia o greetd sozinho. Não definir services.greetd manualmente.

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # From: https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  #
  # Sysc-greet
  #

  services.sysc-greet = {
    enable = true;
    compositor = "niri";
    niriPackage = pkgs.niri;
  };
}
