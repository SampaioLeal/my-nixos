{
  wayland.windowManager.hyprland.settings.windowrule = [
    # Ignore maximize requests from all apps. You'll probably like this.
    "suppressevent maximize, class:^(.*)$"
    "nofocus on, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"
    "move 20 monitor_h-120, float, class:hyprland-run"

    "float, title:^(Picture-in-Picture)$"
    "pin, title:^(Picture-in-Picture)$"

    "dimaround on, class:^(xdg-desktop-portal-gtk)$"
    "dimaround on, class:^(polkit-gnome-authentication-agent-1)$"
    "dimaround on, class:^(zen-beta)$, title:^(File Upload)$"

    "opacity 1 override, class:com.mitchellh.ghostty"
    "opacity 1 override, class:zen-beta"
  ];
}
