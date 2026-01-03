{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
    "$terminal" = "ghostty";
    "$fileManager" = "nautilus";
    "$menu" = "wofi";
    "$browser" = "zen-beta";

    # https://wiki.hypr.land/Configuring/Variables/#input
    input = {
      kb_layout = "br";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = false;
      };
    };

    monitor = [
      "DP-3, 2560x1080@75, 0x0, 1"
      "HDMI-A-1, 2560x1080@60, 2560x-800, 1, transform, 1"
    ];

    exec-once = [
      "waybar"
      "hyprpaper"
      "hypridle"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
    ];

    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "rgb(0789ad)";
      "col.inactive_border" = "rgba(595959aa)";
      resize_on_border = true;
      allow_tearing = true;
      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      rounding_power = 2;

      # Change transparency of focused and unfocused windows
      active_opacity = 0.9;
      inactive_opacity = 0.9;
      fullscreen_opacity = 1;

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };

      # https://wiki.hypr.land/Configuring/Variables/#blur
      blur = {
        enabled = true;

        brightness = 0.9;
        contrast = 1;
        noise = 0;

        vibrancy = 0.2;
        vibrancy_darkness = 0.5;

        passes = 3;
        size = 10;

        ignore_opacity = true;
        xray = true;

        new_optimizations = true;

        popups = true;
        popups_ignorealpha = 0.2;
      };
    };

    animations = {
      enabled = true;

      # Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
      bezier = [
        #   NAME,        X0,   Y0,   X1,   Y1
        "easeOutQuint,   0.23, 1,    0.32, 1"
        "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        "linear,         0,    0,    1,    1"
        "almostLinear,   0.5,  0.5,  0.75, 1"
        "quick,          0.15, 0,    0.1,  1"
      ];

      animation = [
        # Default animations, see https://wiki.hypr.land/Configuring/Animations/
        # NAME,         ONOFF, SPEED, CURVE,        [STYLE]
        "global,        1,     10,    default"
        "border,        1,     5.39,  easeOutQuint"
        "windows,       1,     4.79,  easeOutQuint"
        "windowsIn,     1,     4.1,   easeOutQuint, popin 87%"
        "windowsOut,    1,     1.49,  linear,       popin 87%"
        "fadeIn,        1,     1.73,  almostLinear"
        "fadeOut,       1,     1.46,  almostLinear"
        "fade,          1,     3.03,  quick"
        "layers,        1,     3.81,  easeOutQuint"
        "layersIn,      1,     4,     easeOutQuint, fade"
        "layersOut,     1,     1.5,   linear,       fade"
        "fadeLayersIn,  1,     1.79,  almostLinear"
        "fadeLayersOut, 1,     1.39,  almostLinear"
        "workspaces,    1,     1.94,  almostLinear, fade"
        "workspacesIn,  1,     1.21,  almostLinear, fade"
        "workspacesOut, 1,     1.94,  almostLinear, fade"
        "zoomFactor,    1,     7,     quick"
      ];
    };

    # See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
      smart_resizing = true;
      permanent_direction_override = false;
    };

    # See https://wiki.hypr.land/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    # https://wiki.hypr.land/Configuring/Variables/#misc
    misc = {
      force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };

    bind = [
      # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
      "$mainMod, Q, exec, $terminal"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, B, exec, $browser"
      "$mainMod, C, killactive,"
      "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, $menu"
      "$mainMod, L, exec, hyprlock"
      "$mainMod, P, pseudo," # dwindle
      "$mainMod, J, togglesplit," # dwindle

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Print screen
      ", Print, exec, hyprshot -m region"
    ];
    # ++ (
    #     # workspaces
    #     # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
    #     builtins.concatLists (builtins.genList (i:
    #         let ws = i + 1;
    #         in [
    #         "$mod, code:1${toString i}; workspace, ${toString ws}"
    #         "$mod SHIFT, code:1${toString i}; movetoworkspace, ${toString ws}"
    #         ]
    #     )
    #     9)
    # );

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Laptop multimedia keys for volume and LCD brightness
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    # Requires playerctl
    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    windowrule = [
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

    "plugin:dynamic-cursors" = {
      enabled = true;
      mode = "none";
    };
  };
}
