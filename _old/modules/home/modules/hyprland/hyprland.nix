{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Hyprland Ecosystem
    hyprpaper
    hyprpicker
    hyprlauncher
    hypridle
    hyprlock
    hyprsysteminfo
    hyprsunset
    hyprpolkitagent
    hyprland-qt-support
    hyprqt6engine
    hyprpwcenter
    hyprshutdown
    hyprshot
    hyprpanel

    # HyprPanel deps
    aylurs-gtk-shell-git
    libgtop
    dart-sass
    wl-clipboard
    upower
    gvfs
    gtksourceview3
    libsoup3

    # Hyprland Deps
    wayland
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
}
