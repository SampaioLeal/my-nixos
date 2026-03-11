{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.sysc-greet.nixosModules.default
  ];

  services.logind.settings.Login.HandlePowerKey = "suspend";

  #
  # Greetd
  #

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = "${pkgs.tuigreet}/bin/tuigreet --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --time --remember --remember-user-session --user-menu --user-menu-min-uid 1000 --asterisks --power-shutdown 'shutdown -P now' --power-reboot 'shutdown -r now'";
      };
    };
  };

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
    compositor = "hyprland";
  };
}
