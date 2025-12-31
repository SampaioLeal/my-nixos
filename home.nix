{ lib, pkgs, inputs, ... }:
{
    imports = [
        inputs.zen-browser.homeModules.beta
        ./terminal
    ];
    
    home = {
        username = "sampaiol";
        homeDirectory = "/home/sampaiol";
        stateVersion = "25.11";

        sessionVariables = {
            NIXOS_OZONE_WL = "1";
        };

        packages = with pkgs; [
            zathura
            cliphist
            dunst
            jq
            fastfetch
            spotify
            discord
            hyprlauncher
        ];
    };

    programs.zen-browser = {
        enable = true;
    };

    programs.git = {
        enable = true;
        userName = "Sampaio Leal";
        userEmail = "sampaioleal14@gmail.com";
    };

    programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
            dracula-theme.theme-dracula
        ];
    };

    #
    # Waybar
    #

    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
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
                        "(.*) - Chromium" = " $1";
                        "(.*) - VSCodium" = "󰨞 $1";
                        "(.*) - Thunar" = " $1";
                        "(.*) - Discord" = " $1";
                        "Unity - (.*)" = " $1";
                        "Steam" = " Steam";
                        "WhatsDesk" = " WhatsDesk";
                        "Kitty" = " $1";
                        "class<org.telegram.desktop>" = " $1";
                        "class<spotify>" = " Spotify";
                        "class<unityhub>" = " UnityHub";
                        "class<zenity>" = "  Lenovo Vantage";
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
                        "(.*) - Chromium" = " ";
                        "(.*)VSCodium" = "󰨞 ";
                        "class<Codium>" = "󰨞 ";
                        "(.*) - Thunar" = " ";
                        "class<discord>" = " ";
                        "Steam" = " ";
                        "class<org.telegram.desktop>" = " ";
                        "WhatsDesk" = " ";
                        "Kitty" = " ";
                        "class<spotify>" = " ";
                        "class<unityhub>" = " ";
                        "class<Unity>" = " ";
                        "class<zenity" = " ";
                        "class<MuPDF>" = " ";
                        "title<Aggiornamenti>" = " ";
                        "title<Pacchetti Installati>" = " ";
                    };
                    "persistent-workspaces" = {
                        "*" = 10;
                        "DP-3" = [11 12];
                        "HDMI-A-1" = [11 12];
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
                        mode          = "month";
                        mode-mon-col  = 3;
                        weeks-pos     = "right";
                        on-scroll     = 1;
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
                    "format-icons" = [" "];
                    "format-alt-click" = "click-right";
                    "critical-threshold" = 80;
                    "format-critical" = " {temperatureC}°C";
                    "on-click" = "kitty --title btop sh -c 'btop'";
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
                    "on-click-right" = "kitty -e nmtui";
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
                    "format-icons" = [""];
                    # "on-click" = "sh -c'(sleep 0.5s; wlogout --protocol layer-shell)' & disown";
                    "on-click" = "wlogout --protocol layer-shell";
                    "tooltip-format" = "Opzioni di Spegnimento";
                    tooltip = true;
                };

                "custom/lock_screen" = {
                    format = "{icon}";        
                    "format-icons" = [""];
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
                    "on-click" = "kitty --title Aggiornamenti sh -c ~/.config/waybar/scripts/installaupdates.sh";
                    "on-click-right" = "kitty --title 'Pacchetti Installati' sh -c ~/.config/waybar/scripts/listpackages.sh";
                    tooltip = true;
                };

                "custom/wol" = {
                    format = "{icon}";
                    "format-icons" = [""];
                    "tooltip-format" = "Sveglia e Connetti ad Host:\n<small>{}</small>";
                    escape = true;
                    "return-type" = "json";
                    exec = "~/.config/waybar/scripts/tailscaleinfo.sh";
                    interval = 60;
                    "on-click" = "~/.config/waybar/scripts/wol.sh";
                    "on-click-right" = "kitty --title 'Connetti a '$(cat ~/.config/.secrets/hostname.txt)'' sh -c ~/.config/waybar/scripts/connectssh.sh";
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
                    "format-icons" = ["󰀻 "];
                    "tooltip-format" = "Aplicações";
                    "on-click" = "rofi -show drun";
                };

                "custom/wl-gammarelay-temperature" = {
                    format = "{} {icon}";
                    format-alt = "{icon}"; 
                    "format-icons" = [""];
                    exec = "wl-gammarelay --subscribe Temperature";
                    "on-scroll-up" = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100";
                    "on-scroll-down" = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100";
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
        };
        style = ''
            * {
                border: none;
                border-radius: 0;
                font-family: 'FiraCode Nerd Font', 'Font Awesome 7 Free Regular', sans-serif;
                font-weight: bold;
                font-size: 14px;
                min-height: 0;
            }

            window#waybar {
                background-color: rgba(0, 0, 0, 0);
                border-bottom: 0.5px solid #fffff0;
                background: rgba(21, 18, 27, 0.6);
                color: #cdd6f4;
                transition-property: background-color;
                transition-duration: .5s;
            }

            window#waybar.hidden {
                opacity: 0.2;
            }

            tooltip {
                background: rgba(8, 7, 10, 0.8);
                border-radius: 18px;
                border-width: 2px;
                border-style: solid;
                border-color: #11111b;
            }


            #workspaces {
                background: rgba(8, 7, 10, 0.6);
                margin: 5px 5px 5px 5px;
                padding: 6px 5px;
                border-radius: 18px;
                margin-top: 7px;
                margin-bottom: 7px;
                /* margin-left: 5px;
                margin-right: 5px; */
                border: 0.5px solid #032412;
            }

            #workspaces button {
                padding: 0px 5px;
                margin: 0px 3px;
                border-radius: 16px;
                color: #cdd6f4;
                background-color: #2f354a;
                transition: all 0.3s ease-in-out;
            }


            #workspaces button.empty {
                opacity: 0.4;
            }

            #workspaces button.active {
                color: #2f354a;
                background-color: #cdd6f4;
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
                transition: all 0.3s ease-in-out;
                /*opacity: 1.0;*/
            }

            #workspaces button.urgent {
                background-color: #cdd6f4;
                color: #2f354a;
                padding: 0 0 0 5px;
                border-radius: 16px;
                min-width: 40px;
                background-size: 300% 300%;
            }

            #workspaces button:hover {
                background-color: #cdd6f4;
                color: #2f354a;
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
            }

            #clock,
            #network,
            #bluetooth,
            #window,
            #custom-rofi,
            #custom-power_btn,
            #custom-lock_screen,
            #custom-wol,
            #custom-updates,
            #custom-github,
            #custom-media,
            #power-profiles-daemon,
            #temperature,
            #battery,
            #backlight,
            #custom-wl-gammarelay-temperature,
            #pulseaudio,
            #tray,
            #custom-swaync {
                background-color: #2f354a;
                margin: 0 0 0 0;
                padding: 0px 7px 0px 7px;
                border-radius: 18px;
                margin-top: 10px;
                margin-bottom: 10px;
                border: none;
            }



            /* LEFT MODULES */


            #clock {
                border-radius: 18px 0 0 18px;
                color: #fab387;
                margin-left: 5px;
            }

            #network {
                border-radius: 0px 0 0 0px;
                color: #f9e2af;
            }

            #network.disabled {
                color: #f9e2af;
            }


            #bluetooth {
                border-radius: 0 18px 18px 0px;
                color: #89b4fa;
            } 

            #window {
                background: #cdd6f4;
                color: #1e1e2e;
                border-radius: 18px;
                margin-left: 20px;
                margin-right: 20px;
            }

            window#waybar.empty #window {
                background-color: transparent;
            }

            /* CENTER MODULES */

            #custom-rofi {
                opacity: 0.6
            }

            #custom-power_btn {
                color :#9c8bfd;
                border-radius: 18px 0px 0px 18px;
            }

            #custom-lock_screen {
                color :#9c8bfd;
                border-radius: 0px 0px 0px 0px;
            }

            #custom-wol {
                border-radius: 0px 0px 0px 0px;    
            }

            #custom-wol.green {
                color: #a6e3a1;
            }

            #custom-wol.red {
                color: #fd8b9e; 
            }

            #custom-updates.green {
                color: #a6e3a1;
            }

            #custom-updates.yellow {
                color: #e8db92;
            }

            #custom-updates.red {
                color: #eba0ac;
            }

            #custom-github {
                border-radius: 0px 18px 18px 0px;
            }

            #custom-github.green {
                color: #a6e3a1;
            }

            #custom-github.yellow {
                color: #e8db92;
            }

            #custom-github.red {
                color: #eba0ac;
            }



            /* RIGHT MODULES */


            #custom-media {
                padding-right: 10px;
                margin-right: 10px;
                margin-left: 10px;
            }

            #custom-media.custom-spotify {
                color: #1db954;
            }

            #temperature {
                color: #8be9fd;
                border-radius: 18px 0px 0px 18px;
            }

            #temperature.critical {
                color: #eba0ac;
            }

            #battery {
                border-radius: 0px 0px 0px 0px;
                padding: 0px 0px 0px 7px;
                color: #a6e3a1;
            }

            #battery.warning {
                color: #e8db92;
            }

            #battery.critical {
                color: #eba0ac;
            }

            #power-profiles-daemon{
                border-radius: 0px 0px 0px 0px;
                padding: 0px 0px 0px 7px;
            }

            #power-profiles-daemon.power-saver{
                color: #a6e3a1;
            }

            #power-profiles-daemon.balanced{
                color: #8be9fd;
            }

            #power-profiles-daemon.performance{
                color: #e8db92;
            }

            #custom-wl-gammarelay-temperature {
                border-radius: 0px 0px 0px 0px;
                padding: 0px 0px 0px 7px;
                color: #d99280;
            }

            #backlight {
                border-radius: 0px 18px 18px 0px;
                margin-right: 5px
            }

            #pulseaudio {
                border-radius: 18px 0 0 18px;
                color: #89b4fa;
            }

            #pulseaudio.microphone {
                border-radius: 0 18px 18px 0;
                color: #cba6f7;
                margin-right: 5px;
            }

            #tray {
                border-radius: 18px 0 0 18px;
            }

            #custom-swaync {
                border-radius: 0px 18px 18px 0px;
                margin-right: 5px;
            }

            #custom-updates {
                border-radius: 0px 0px 0px 0px;
                padding: 0px 0px 0px 7px;
            }
        '';
    };

    #
    # Hyprland Ecosystem
    #

    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        plugins = [
            pkgs.hyprlandPlugins.hypr-dynamic-cursors
        ];
        settings = {
            "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
            "$terminal" = "kitty";
            "$fileManager" = "thunar";
            "$menu" = "hyprlauncher";

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

            # See https://wiki.hypr.land/Configuring/Gestures
            gesture = "3, horizontal, workspace";

            monitor = [
                "DP-3, 2560x1080@75, 0x0, 1"
                "HDMI-A-1, 2560x1080@60, 2560x-800, 1, transform, 1"
            ];

            exec-once = [
                "waybar"
                "hyprpaper"
            ];

            env = [
                "XCURSOR_SIZE,24"
                "HYPRCURSOR_SIZE,24"
            ];

            general = {
                gaps_in = 5;
                gaps_out = 20;
                border_size = 2;
                "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";
                resize_on_border = false;
                allow_tearing = false;
                layout = "dwindle";
            };

            decoration = {
                rounding = 10;
                rounding_power = 2;

                # Change transparency of focused and unfocused windows
                active_opacity = 1.0;
                inactive_opacity = 1.0;

                shadow = {
                    enabled = true;
                    range = 4;
                    render_power = 3;
                    color = "rgba(1a1a1aee)";
                };

                # https://wiki.hypr.land/Configuring/Variables/#blur
                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;
                    vibrancy = 0.1696;
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
            };

            # See https://wiki.hypr.land/Configuring/Master-Layout/ for more
            master = {
                new_status = "master";
            };

            # https://wiki.hypr.land/Configuring/Variables/#misc
            misc = {
                force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
                disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
            };
            
            bind = [
                # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
                "$mainMod, Q, exec, $terminal"
                "$mainMod, C, killactive,"
                "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
                "$mainMod, E, exec, $fileManager"
                "$mainMod, V, togglefloating,"
                "$mainMod, R, exec, $menu"
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
            ];
        };
    };

    programs.hyprlock = {
        enable = true;
    };

    programs.hyprpanel = {
        enable = true;
    };

    programs.hyprshot = {
        enable = true;
    };
    
    services.hypridle = {
        enable = true;
    };

    services.hyprpaper = {
        enable = true;
    };

    services.hyprpolkitagent = {
        enable = true;
    };

    services.hyprsunset = {
        enable = true;
    };
}

# https://github.com/hyprland-community/awesome-hyprland
# https://raw.githubusercontent.com/00Darxk/dotfiles/refs/heads/main/showcases/sayu-showcase.png
# https://github.com/00Darxk/dotfiles/blob/main/waybar/style.css
# https://home-manager-options.extranix.com/?query=hyprlock&release=release-25.11
# https://ghostty.org/
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/core/user.nix?ref_type=heads
# https://wearewaylandnow.com/