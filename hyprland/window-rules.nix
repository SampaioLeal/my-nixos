{
  wayland.windowManager.hyprland.settings.windowrule = [
    # Ignore maximize requests from all apps. You'll probably like this.
    "suppress_event maximize, match:class ^(.*)$"
    "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
    "move (20) (monitor_h-120), float on, match:class hyprland-run"

    "float on, pin on, match:title ^(Picture-in-Picture)$"

    "dim_around on, match:class ^(xdg-desktop-portal-gtk)$"
    "dim_around on, match:class ^(polkit-gnome-authentication-agent-1)$"
    "dim_around on, match:class ^(zen-beta)$, match:title ^(File Upload)$"

    "opacity 1 override, match:class com.mitchellh.ghostty"
    "opacity 1 override, match:class zen-beta"
  ];
}
