{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.waybar.settings.mainBar = {
    output = [
      "DP-3"
      "HDMI-A-1"
    ];
    # position = "top";
    # exclusive = true;
    # passthrough = false;
    # gtk-layer-shell = true;
    # height = 30;
    layer = "top";
    height = 0;
    width = 0;
    margin = "0";
    spacing = 0;
    mode = "dock";

    modules-left = [
      "custom/left_div#1"
      "hyprland/workspaces"
      "custom/right_div#1"
      "hyprland/window"
    ];
    modules-center = [
      "hyprland/windowcount"
      "custom/left_div#1"
      "temperature"
      "custom/left_div#2"
      "memory"
      "custom/left_div#3"
      "cpu"
      "custom/left_inv#1"
      "custom/left_div#4"
      "custom/distro"
      "custom/right_div#4"
      "custom/right_inv#1"
      "idle_inhibitor"
      "clock#time"
      "custom/right_div#3"
      "clock#date"
      "custom/right_div#2"
      "network"
      "bluetooth"
      "custom/system_update"
      "custom/right_div#1"
    ];
    modules-right = [
      "mpris"
      "custom/left_div#1"
      "tray"
      "custom/left_div#2"
      "privacy"
      "custom/left_div#3"
      "group/wireplumber"
      "custom/left_inv#1"
      "custom/power_menu"
    ];

    #
    # CPU
    #

    cpu = {
      interval = 10;
      format = "󰍛 {usage}%";
      format-warning = "󰀨 {usage}%";
      format-critical = "󰀨 {usage}%";
      min-length = 7;
      max-length = 7;
      states = {
        warning = 75;
        critical = 90;
      };
      # tooltip = false;
      tooltip-format = "CPU Usage: {usage}%";
    };

    #
    # Clock
    #

    "clock#time" = {
      format = "{:%H:%M}";
      min-length = 5;
      max-length = 5;
      tooltip-format = "<b>Standard Time</b>: <span text_transform='lowercase'>{:%I:%M %p}</span>";
    };
    "clock#date" = {
      format = "󰸗 {:%d-%m}";
      min-length = 8;
      max-length = 8;
      tooltip-format = "{calendar}";
      calendar = {
        mode = "month";
        mode-mon-col = 4;
        format = {
          months = "<span alpha='100%'><b>{}</b></span>";
          days = "<span alpha='90%'>{}</span>";
          weekdays = "<span alpha='80%'><i>{}</i></span>";
          today = "<span alpha='100%'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click = "mode";
      };
    };

    #
    # Bluetooth
    #

    bluetooth = {
      format = "󰂯";
      format-disabled = "󰂲";
      format-off = "󰂲";
      format-on = "󰂰";
      format-connected = "󰂱";
      min-length = 2;
      max-length = 2;
      on-click = "hyprctl dispatch exec '[float]' 'ghostty -e bluetui'";
      on-click-right = "bluetoothctl power off && notify-send 'Bluetooth Off' -i 'network-bluetooth-inactive' -h string:x-canonical-private-synchronous:bluetooth";
      tooltip-format = "Device Addr: {device_address}";
      tooltip-format-disabled = "Bluetooth Disabled";
      tooltip-format-off = "Bluetooth Off";
      tooltip-format-on = "Bluetooth Disconnected";
      tooltip-format-connected = "Device: {device_alias}";
      tooltip-format-enumerate-connected = "Device: {device_alias}";
      tooltip-format-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
      tooltip-format-enumerate-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
    };

    #
    # Idle Inhibitor
    #

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "󰈈";
        deactivated = "󰈉";
      };
      min-length = 3;
      max-length = 3;
      tooltip-format-activated = "<b>Idle Inhibitor</b>: Activated";
      tooltip-format-deactivated = "<b>Idle Inhibitor</b>: Deactivated";
      start-activated = false;
    };

    #
    # Memory
    #

    memory = {
      interval = 10;
      format = "󰘚 {percentage}%";
      format-warning = "󰀧 {percentage}%";
      format-critical = "󰀧 {percentage}%";
      states = {
        warning = 75;
        critical = 90;
      };
      min-length = 7;
      max-length = 7;
      tooltip-format = "Memory Used: {used:0.0f}/{total:0.0f} GB";
    };

    #
    # Multimedia
    #

    mpris = {
      format = "{player_icon} {title} - {artist}";
      format-paused = "{status_icon} {title} - {artist}";
      tooltip-format = "Playing: {title} - {artist}";
      tooltip-format-paused = "Paused: {title} - {artist}";
      player-icons = {
        default = "󰐊";
        spotify = "";
      };
      status-icons = {
        paused = "󰏤";
      };
      max-length = 40;
    };

    #
    # Network
    #

    network = {
      interval = 10;
      format = "󰤨";
      format-ethernet = "󰈀";
      format-wifi = "{icon}";
      format-disconnected = "󰤯";
      format-disabled = "󰤮";
      format-icons = [
        "󰤟"
        "󰤢"
        "󰤥"
        "󰤨"
      ];
      min-length = 2;
      max-length = 2;
      on-click = "hyprctl dispatch exec '[float; size 36 8; center]' 'ghostty -e nmtui";
      # on-click-right = "nmcli radio wifi off && notify-send 'Wi-Fi Disabled' -i 'network-wireless-off' -h string:x-canonical-private-synchronous:network";
      tooltip-format = "<b>Gateway</b>: {gwaddr}";
      tooltip-format-ethernet = "<b>Interface</b>: {ifname}";
      tooltip-format-wifi = "<b>Network</b>: {essid}\n<b>IP Addr</b>: {ipaddr}/{cidr}\n<b>Strength</b>: {signalStrength}%\n<b>Frequency</b>: {frequency} GHz";
      tooltip-format-disconnected = "Wi-Fi Disconnected";
      tooltip-format-disabled = "Wi-Fi Disabled";
    };

    #
    # Wireplumber
    #

    "group/wireplumber" = {
      orientation = "horizontal";
      modules = [
        "wireplumber#output"
        "wireplumber#input"
      ];
      drawer = {
        transition-left-to-right = false;
      };
    };
    "wireplumber#output" = {
      format = "{icon} {volume}%";
      format-muted = "󰝟 {volume}%";
      format-icons = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
      min-length = 7;
      max-length = 7;
      on-click = "~/.config/waybar/scripts/volume.sh output mute";
      on-scroll-up = "~/.config/waybar/scripts/volume.sh output raise";
      on-scroll-down = "~/.config/waybar/scripts/volume.sh output lower";
      tooltip-format = "Device: {node_name}";
      node-type = "Audio/Sink";
    };
    "wireplumber#input" = {
      format = "󰍬 {volume}%";
      format-muted = "󰍭 {volume}%";
      min-length = 7;
      max-length = 7;
      on-click = "~/.config/waybar/scripts/volume.sh input mute";
      on-scroll-up = "~/.config/waybar/scripts/volume.sh input raise";
      on-scroll-down = "~/.config/waybar/scripts/volume.sh input lower";
      tooltip-format = "Device: {node_name}";
      node-type = "Audio/Source";
    };

    #
    # Temperature
    #

    temperature = {
      # thermal-zone = 0;
      hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
      critical-threshold = 90;
      interval = 10;
      format-critical = "󰀦 {temperatureC}°C";
      format = "{icon} {temperatureC}°C";
      format-icons = [
        "󱃃"
        "󰔏"
        "󱃂"
      ];
      min-length = 8;
      max-length = 8;
      tooltip-format = "Fahrenheit: {temperatureF}°F";
    };

    #
    # Distro
    #

    "custom/distro" = {
      format = "";
      tooltip = false;
      on-click = "xdg-open https://mynixos.com/";
    };

    #
    # Power Menu
    #

    "custom/power_menu" = {
      format = "󰤄";
      on-click = "hyprctl dispatch exec '[float; size 36 8; center]' 'ghostty -e ~/.config/waybar/scripts/power-menu.sh'";
      tooltip-format = "Power Menu";
    };

    #
    # System Update
    #

    "custom/system_update" = {
      # https://nlewo.github.io/nixos-manual-sphinx/installation/upgrading.xml.html
      # exec = "~/.config/waybar/scripts/system-update.sh module";
      return-type = "json";
      interval = 3600;
      signal = 1;
      format = "{}";
      min-length = 2;
      max-length = 2;
      # on-click = "ghostty -e ~/.config/waybar/scripts/system-update.sh";
      on-click-right = "pkill -RTMIN+1 waybar";
    };

    #
    # Tray
    #
    # Style
    # #tray
    # #tray menu for the context menu
    # #tray > .passive for icons with status Passive
    # #tray > .active for icons with status Active
    # #tray > .needs-attention for icons with status NeedsAttention

    tray = {
      icon-size = 16;
      spacing = 12;
      cursor = true;
    };

    #
    # Hyprland
    #

    "hyprland/window" = {
      format = "{}";
      rewrite = {
        # TODO: fix this
        "" = "Desktop";
        zen-beta = "Zen Browser";
        ghostty = "Terminal";
        zsh = "Terminal";
        "~" = "Terminal";
      };
      swap-icon-label = false;
    };
    "hyprland/windowcount" = {
      format = "[{}]";
      swap-icon-label = false;
    };
    "hyprland/workspaces" = {
      format = "{icon}";
      format-icons = {
        active = "";
        default = "";
      };
      persistent-workspaces = {
        "*" = 5;
      };
      workspace-taskbar = {
      };
      on-scroll-up = "hyprctl dispatch workspace +1";
      on-scroll-down = "hyprctl dispatch workspace -1";
      cursor = true;
    };

    #
    # Privacy
    #
    # Styles:
    # #privacy
    # #privacy-item
    # #privacy-item.screenshare
    # #privacy-item.audio-in
    # #privacy-item.audio-out

    privacy = {
      icon-spacing = 4;
      icon-size = 18;
      transition-duration = 250;
      modules = [
        {
          type = "screenshare";
          tooltip = true;
          tooltip-icon-size = 24;
        }
        {
          type = "audio-out";
          tooltip = true;
          tooltip-icon-size = 24;
        }
        {
          type = "audio-in";
          tooltip = true;
          tooltip-icon-size = 24;
        }
      ];
      ignore-monitor = true;
      ignore = [
        {
          type = "audio-in";
          name = "cava";
        }
        {
          type = "screenshare";
          name = "obs";
        }
      ];
    };

    #
    # Dividers
    #

    "custom/left_div#1" = {
      format = "";
      tooltip = false;
    };

    "custom/left_div#2" = {
      format = "";
      tooltip = false;
    };
    "custom/left_div#3" = {
      format = "";
      tooltip = false;
    };
    "custom/left_div#4" = {
      format = "";
      tooltip = false;
    };
    "custom/left_div#5" = {
      format = "";
      tooltip = false;
    };
    "custom/left_div#6" = {
      format = "";
      tooltip = false;
    };
    "custom/left_div#7" = {
      format = "";
      tooltip = false;
    };
    "custom/left_div#8" = {
      format = "";
      tooltip = false;
    };
    "custom/left_inv#1" = {
      format = "";
      tooltip = false;
    };
    
    "custom/right_div#1" = {
      format = "";
      tooltip = false;
    };
    "custom/right_div#2" = {
      format = "";
      tooltip = false;
    };
    "custom/right_div#3" = {
      format = "";
      tooltip = false;
    };
    "custom/right_div#4" = {
      format = "";
      tooltip = false;
    };
    "custom/right_div#5" = {
      format = "";
      tooltip = false;
    };
    "custom/right_inv#1" = {
      format = "";
      tooltip = false;
    };
  };
}
