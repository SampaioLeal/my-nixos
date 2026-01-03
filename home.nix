{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./browser
    ./hyprland
    ./launcher
    ./notifications
    ./spotify
    ./terminal
    ./vscode
    ./waybar
  ];

  home = {
    username = "sampaiol";
    homeDirectory = "/home/sampaiol";
    stateVersion = "25.11";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    packages = with pkgs; [
      # CLI Utils
      fastfetch
      moreutils
      ripgrep
      lshw
      appimage-run
      tldr
      fzf
      bat
      asciinema
      asciinema-agg
      progress
      htop
      btop
      lm_sensors
      wl-clipboard
      cliphist
      xdg-utils

      # Developer Tools
      jq
      gh
      lazygit
      lazydocker
      bruno
      bruno-cli
      warp-terminal
      gping
      hyperfine
      pastel
      scooter
      tokei
      openssl
      git-graph
      hyprpicker
      nixfmt
      dnsutils
      nmap
      rdap

      # Multimedia
      lowfi
      zathura
      imv
      mpv
      ffmpeg
      ffmpegthumbnailer
      imagemagick

      # Communication
      discord

      # Productivity and office
      obsidian

      # File management and archives
      fd
      eza
      yazi
      broot
      p7zip
      unzip
      zip
      unrar
      file-roller
      nautilus

      # Disk Management
      ncdu
      duf
      caligula
      udiskie

      # Misc
      obs-studio
      cmatrix
      lolcat
      swappy
      asciiquarium-transparent
      countryfetch
      cowsay
      figlet
      lavat
      bemoji
      gnome-calculator
      polkit_gnome
    ];
  };

  # home.pointerCursor = {
  #   package = pkgs.catppuccin-cursors.mochaPink;
  #   name = "Catppuccin-Mocha-Pink-Cursors";
  #   size = 40;
  #   gtk.enable = true;
  # };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font";
      size = 10;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.sessionVariables.GTK_THEME = "Adwaita-dark";

  qt = {
    enable = true;
    platformTheme = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sampaio Leal";
        email = "sampaioleal14@gmail.com";
      };
    };
  };

  home.file.".vscode/argv.json" = {
    text = ''
      {
        "enable-crash-reporter": true,

        "crash-reporter-id": "2837d826-01c9-4aae-922d-9daffc753f01",

        "password-store":"gnome-libsecret"
      }
    '';
  };

  #
  # Hyprland Ecosystem
  #

  programs.hyprlock = {
    enable = true;
  };

  programs.hyprshot = {
    enable = true;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        # {
        #   # monitor backlight restore.
        #   timeout = 150; # 2.5min.
        #   on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
        #   on-resume = "brightnessctl -r";
        # }
        # {
        #   # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        #   timeout = 150; # 2.5min.
        #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
        #   on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        # }
        {
          timeout = 600; # 10min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 900; # 15min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
          # TODO: fix this
          timeout = 3600; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };

  services.hyprsunset = {
    enable = true;
  };

  # xdg.mime = {
  #   enable = true;
  #   defaultApplications = {
  #     "application/pdf" = "org.pwmt.zathura.desktop";
  #     "application/vnd.apple.mpegurl" = "vlc.desktop";
  #     "application/x-extension-htm" = "firefox.desktop";
  #     "application/x-extension-html" = "firefox.desktop";
  #     "application/x-extension-shtml" = "firefox.desktop";
  #     "application/x-extension-xht" = "firefox.desktop";
  #     "application/x-extension-xhtml" = "firefox.desktop";
  #     "application/x-shellscript" = "emacsclient.desktop";
  #     "application/xhtml+xml" = "firefox.desktop";
  #     "audio/x-mpegurl" = "vlc.desktop";
  #     "image/png" = "feh.desktop";
  #     "text/*" = "emacsclient.desktop";
  #     "text/css" = "emacsclient.desktop";
  #     "text/html" = "firefox.desktop";
  #     "text/markdown" = "calibre-ebook-viewer.desktop";
  #     "text/plain" = "emacsclient.desktop";
  #     "video/*" = "umpv.desktop";
  #     "x-scheme-handler/chrome" = "firefox.desktop";
  #     "x-scheme-handler/http" = "firefox.desktop";
  #     "x-scheme-handler/https" = "firefox.desktop";
  #     "x-scheme-handler/mpv" = "open-in-mpv.desktop";
  #   };
  # };
}

# https://github.com/hyprland-community/awesome-hyprland
# https://raw.githubusercontent.com/00Darxk/dotfiles/refs/heads/main/showcases/sayu-showcase.png
# https://github.com/00Darxk/dotfiles/blob/main/waybar/style.css
# https://home-manager-options.extranix.com/?query=hyprlock&release=release-25.11
# https://ghostty.org/
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/core/user.nix?ref_type=heads
# https://wearewaylandnow.com/
