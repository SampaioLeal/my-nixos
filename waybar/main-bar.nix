{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    mod = "dock";
    exclusive = true;
    passthrough = false;
    gtk-layer-shell = true;
    height = 30;
    output = [
      "DP-3"
      "HDMI-A-1"
    ];

    modules-left = [
      "clock"
      "network"
      "bluetooth"
      "hyprland/window"
    ];
    modules-center = [
      "custom/rofi"
      "hyprland/workspaces"
      "group/exit"
      "custom/wol"
      "custom/updates"
      "custom/github"
    ];
    modules-right = [
      "custom/media"
      "group/hardware"
      "group/audio"
      "tray"
      "custom/swaync"
    ];

    # Group Hardware
    "group/hardware" = {
      orientation = "horizontal";
      modules = [
        "temperature"
        "battery"
        "power-profiles-daemon"
        "custom/wl-gammarelay-temperature"
        "backlight"
      ];
    };

    # Group IO Audio
    "group/audio" = {
      orientation = "horizontal";
      modules = [
        "pulseaudio"
        "pulseaudio#microphone"
      ];
    };

    # Group Exit
    "group/exit" = {
      orientation = "horizontal";
      modules = [
        "custom/power_btn"
        "custom/lock_screen"
      ];
    };

    "hyprland/window" = {
      format = "{}";
      rewrite = {
        "(.*) - Zen Browser" = " $1";
        "(.*) - Visual Studio Code" = "󰨞 $1";
        "(.*) - Thunar" = " $1";
        "(.*) - Discord" = " $1";
        "Ghostty" = " $1";
        "class<spotify>" = " Spotify";
      };
      icon = false;
      separate-output = true;
    };

    "hyprland/workspaces" = {
      "disable-scroll" = true;
      "active-only" = false;
      "all-outputs" = true;
      "on-click" = "activate";
      format = "{name}{icon}{windows}";
      "format-icons" = {
        "urgent" = "  ";
        "default" = " ";
        "empty" = "";
      };
      # TODO: complete
      "window-rewrite" = {
        "title<.*youtube.*>" = " ";
        "(.*) - Zen Browser" = " ";
        "(.*)Visual Studio Code" = "󰨞 ";
        "class<Code>" = "󰨞 ";
        "(.*) - Thunar" = " ";
        "class<discord>" = " ";
        "Ghostty" = " ";
        "class<spotify>" = " ";
        "class<zathura>" = " ";
      };
      "persistent-workspaces" = {
        "*" = 10;
        "DP-3" = [
          11
          12
        ];
        "HDMI-A-1" = [
          11
          12
        ];
      };
    };

    tray = {
      icon-size = 16;
      spacing = 10;
    };

    clock = {
      interval = 1;
      format = "{:%H:%M:%S}";
      locale = "pt_BR.UTF-8";
      tooltip-format = "<tt><small>{calendar}</small></tt>";
      format-alt = "{:L%a %d/%m/%y (%H:%M:%S)}";
      calendar = {
        mode = "month";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        format = {
          months = "<span color='#ffead3'><b>{}</b></span>";
          days = "<span color='#ecc6d9'><b>{}</b></span>";
          weeks = "<span color='#99ffdd'><b>W{}</b></span>";
          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          today = "<span color='#ff6699'><b><u>{}</u></b></span>";
        };
      };
    };

    "backlight" = {
      "device" = "intel_backlight";
      format = "{icon} {percent}%";
      "format-icons" = [
        "󰃞"
        "󰃟"
        "󰃠"
      ];
      "on-scroll-up" = "brightnessctl set 1%+";
      "on-scroll-down" = "brightnessctl set 1%-";
      "tooltip-format" = "Luminosità";
      tooltip = true;
    };

    "battery" = {
      "states" = {
        "good" = 75;
        "warning" = 35;
        "critical" = 20;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-alt = "{time} {icon}";
      "format-icons" = [
        "󰂎"
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
    };

    "pulseaudio" = {
      format = "{icon} {volume}%";
      tooltip = true;
      "format-muted" = "";
      "on-click" = "pamixer -t";
      "on-scroll-up" = "pamixer -i 5";
      "on-scroll-down" = "pamixer -d 5";
      "scroll-step" = 5;
      "format-icons" = {
        "headphone" = "";
        "hands-free" = "";
        "headset" = "";
        "phone" = "";
        "portable" = "";
        "car" = "";
        "default" = [
          ""
          ""
          ""
        ];
      };
    };

    "pulseaudio#microphone" = {
      format = "{format_source}";
      "format-source" = " {volume}%";
      "format-source-muted" = " ";
      "on-click" = "pamixer --default-source -t";
      "on-scroll-up" = "pamixer --default-source -i 5";
      "on-scroll-down" = "pamixer --default-source -d 5";
      "scroll-step" = 5;
    };

    "temperature" = {
      "thermal-zone" = 7;
      interval = 5;
      format = "{icon}{temperatureC}°C";
      "format-icons" = [ " " ];
      "format-alt-click" = "click-right";
      "critical-threshold" = 80;
      "format-critical" = " {temperatureC}°C";
      "on-click" = "ghostty --title btop sh -c 'btop'";
      "tooltip-format" = "Temperatura CPU";
      tooltip = true;
    };

    "network" = {
      # "interface": "wlp2*"; // (Optional) To force the use of this interface
      # internet speed: "
      format-wifi = "{essid} ({signalStrength}%)  ";
      format-ethernet = "{ipaddr}/{cidr} ";
      tooltip-format = "{ifname}: via {gwaddr} \uea9a\n<small>down/up:  {bandwidthDownBytes}   {bandwidthUpBytes}</small>";
      format-linked = "{ifname} (No IP) ";
      format-disconnected = "Disconnesso 󰌙";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
      interval = 1;
      "on-click-right" = "ghostty -e nmtui";
      "max-length" = 30;
    };

    "bluetooth" = {
      format = "  ";
      "format-disabled" = "  ";
      "format-connected" = " {num_connections}";
      "tooltip-format" = "{device_alias}";
      "tooltip-format-connected" = " {device_enumerate}";
      "tooltip-format-enumerate-connected" = "{device_alias}";
      "on-click" = "rfkill toggle bluetooth";
      "on-click-right" = "blueman-manager";
    };

    "power-profiles-daemon" = {
      format = "{icon} ";
      "tooltip-format" = "Opzione di Risparmio: {profile}\nDriver: {driver}";
      tooltip = true;
      "format-icons" = {
        "default" = "";
        "performance" = "";
        "balanced" = "";
        "power-saver" = "";
      };
    };

    "custom/power_btn" = {
      format = "{icon}";
      "format-icons" = [ "" ];
      # "on-click" = "sh -c'(sleep 0.5s; wlogout --protocol layer-shell)' & disown";
      "on-click" = "wlogout --protocol layer-shell";
      "tooltip-format" = "Opzioni di Spegnimento";
      tooltip = true;
    };

    "custom/lock_screen" = {
      format = "{icon}";
      "format-icons" = [ "" ];
      "on-click" = "swaylock";
      "tooltip-format" = "Schermata di Blocco";
      tooltip = true;
    };

    "custom/updates" = {
      # format = " {}";
      format = " {}";
      # "tooltip-format" = "Aggiorna il Sistema\n<small>Pacchetti: {}</small>";
      escape = true;
      "return-type" = "json";
      exec = "~/.config/waybar/scripts/updates.sh";
      "restart-interval" = 3600;
      "on-click" = "ghostty --title Aggiornamenti sh -c ~/.config/waybar/scripts/installaupdates.sh";
      "on-click-right" =
        "ghostty --title 'Pacchetti Installati' sh -c ~/.config/waybar/scripts/listpackages.sh";
      tooltip = true;
    };

    "custom/wol" = {
      format = "{icon}";
      "format-icons" = [ "" ];
      "tooltip-format" = "Sveglia e Connetti ad Host:\n<small>{}</small>";
      escape = true;
      "return-type" = "json";
      exec = "~/.config/waybar/scripts/tailscaleinfo.sh";
      interval = 60;
      "on-click" = "~/.config/waybar/scripts/wol.sh";
      "on-click-right" =
        "ghostty --title 'Connetti a '$(cat ~/.config/.secrets/hostname.txt)'' sh -c ~/.config/waybar/scripts/connectssh.sh";
      tooltip = true;
    };

    "custom/swaync" = {
      format = "{icon}";
      "format-icons" = {
        "notification" = "<span foreground='red'><small><sup>⬤</sup></small></span>";
        "none" = " ";
        "dnd-notification" = "<span foreground='red'><small><sup>⬤</sup></small></span>";
        "dnd-none" = " ";
      };
      "return-type" = "json";
      "exec-if" = "which swaync-client";
      exec = "swaync-client -swb";
      "on-click" = "sleep 0.1 && swaync-client -t -sw";
      escape = true;
      tooltip = false;
    };

    "custom/github" = {
      format = " {}";
      "tooltip-format" = "Notifiche GitHub";
      "return-type" = "json";
      interval = 60;
      exec = "~/.config/waybar/scripts/github.sh";
      "on-click" = "xdg-open https://github.com/notifications";
      tooltip = true;
    };

    "custom/rofi" = {
      format = "{icon} Cerca";
      "format-icons" = [ "󰀻 " ];
      "tooltip-format" = "Aplicações";
      "on-click" = "rofi -show drun";
    };

    "custom/wl-gammarelay-temperature" = {
      format = "{} {icon}";
      format-alt = "{icon}";
      "format-icons" = [ "" ];
      exec = "wl-gammarelay --subscribe Temperature";
      "on-scroll-up" =
        "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100";
      "on-scroll-down" =
        "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100";
      "tooltip-format" = "Temperatura Schermo: {} K";
      tooltip = true;
    };

    "custom/media" = {
      format = "{}";
      escape = true;
      "return-type" = "json";
      "max-length" = 40;
      "on-click" = "playerctl play-pause";
      "on-click-right" = "playerctl stop";
      "smooth-scrolling-threshold" = 10; # This value was tested using a trackpad, it should be lowered if using a mouse.
      "on-scroll-up" = "playerctl next";
      "on-scroll-down" = "playerctl previous";
      exec = "~/.config/waybar/scripts/mediaplayer.py"; # Script in resources/custom_modules folder
      tooltip = true;
      "tooltip-format" = "{}";
    };
  };
}
