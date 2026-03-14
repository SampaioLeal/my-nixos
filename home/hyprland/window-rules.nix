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


# TODO: make this float and center
/**
  Window 557086a68690 -> Extensão: (Bitwarden Gerenciador de Senhas) - Bitwarden — Zen Browser:
        mapped: 1
        hidden: 0
        at: 22,70
        size: 769,988
        workspace: 1 (1)
        floating: 0
        pseudo: 0
        monitor: 1
        class: zen-beta
        title: Extensão: (Bitwarden Gerenciador de Senhas) - Bitwarden — Zen Browser
        initialClass: zen-beta
        initialTitle: Zen Browser
        pid: 4329
        xwayland: 0
        pinned: 0
        fullscreen: 0
        fullscreenClient: 0
        grouped: 0
        tags:
        swallowing: 0
        focusHistoryID: 2
        inhibitingIdle: 0
        xdgTag:
        xdgDescription:
        contentType: none
 */