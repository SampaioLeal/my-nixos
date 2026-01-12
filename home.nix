{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./ags
    ./browser
    ./hyprland
    ./launcher
    ./notifications
    ./spotify
    ./terminal
    ./vscode
  ];

  home = {
    username = "sampaiol";
    homeDirectory = "/home/sampaiol";
    stateVersion = "25.11";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      TERMINAL = "ghostty";
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
      bc
      bluetui

      # Developer Tools
      jq
      entr
      gh
      lazygit
      lazydocker
      # bruno
      # bruno-cli
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
      bitwarden-desktop

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

      # Cursors
      apple-cursor
      whitesur-cursors
      bibata-cursors

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
      bluez
      cava
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font";
      size = 10;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    gtk3 = {
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    gtk4 = {
      enable = true;
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
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
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 3600;
          on-timeout = "systemctl suspend";
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
# https://home-manager-options.extranix.com/?query=hyprlock&release=release-25.11
# https://ghostty.org/
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/core/user.nix?ref_type=heads
# https://wearewaylandnow.com/
