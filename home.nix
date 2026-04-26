{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./home/ags
    ./home/browser
    ./home/hyprland
    ./home/launcher
    ./home/programs
    ./home/spotify
    ./home/terminal
    ./home/vscode
  ];

  home = {
    username = "sampaiol";
    homeDirectory = "/home/sampaiol";
    stateVersion = "25.11";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      TERMINAL = "ghostty";
      BROWSER = "zen";
      EDITOR = "code";
      VISUAL = "code";
    };

    packages = with pkgs; [
      # CLI Utils
      moreutils
      lshw
      appimage-run
      tldr
      asciinema-agg
      progress
      lm_sensors
      wl-clipboard
      xdg-utils
      bc
      bluetui

      # Developer Tools
      entr
      bruno
      bruno-cli
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
      github-copilot-cli
      antigravity
      gemini-cli
      stripe-cli

      # Multimedia
      lowfi
      ffmpeg
      ffmpegthumbnailer
      imagemagick

      # Productivity and office
      bitwarden-desktop

      # File management and archives
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
      usbutils

      # Cursors
      apple-cursor
      whitesur-cursors
      bibata-cursors

      # Misc
      audacity
      cmatrix
      lolcat
      asciiquarium-transparent
      countryfetch
      cowsay
      figlet
      lavat
      bemoji
      gnome-calculator
      libsecret
      bluez
      libnotify
      firefoxpwa

      # Network
      inputs.gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
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
      name = "Inter";
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
      theme = config.gtk.theme;
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

  services.udiskie = {
    enable = true;
    tray = "auto"; # "always", "auto" ou "never"
    settings = {
      program_options = {
        udisks_version = 2;
        notifications = true;
      };
    };
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  # services.ollama = {
  #   enable = true;
  #   port = 11434;
  # };

  xdg = {
    enable = true;
    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        # Web and HTML
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";

        # Videos (MPV)
        "video/*" = "mpv.desktop";
        "x-scheme-handler/mpv" = "mpv.desktop";
        "application/vnd.apple.mpegurl" = "mpv.desktop";
        "audio/x-mpegurl" = "mpv.desktop";

        # Imagens (IMV)
        "image/*" = "imv.desktop";

        # Text and Code (VS Code)
        "text/*" = "code.desktop";
        "application/x-shellscript" = "code.desktop";
        "application/javascript" = "code.desktop";
        "application/json" = "code.desktop";

        # File management
        "inode/directory" = "org.gnome.Nautilus.desktop";

        # Terminal
        "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";

        # PDF
        "application/pdf" = "org.pwmt.zathura.desktop";

        # Other handlers
        "x-scheme-handler/about" = "zen-beta.desktop";
        "x-scheme-handler/unknown" = "zen-beta.desktop";
      };
    };
  };
}

# https://github.com/hyprland-community/awesome-hyprland
# https://raw.githubusercontent.com/00Darxk/dotfiles/refs/heads/main/showcases/sayu-showcase.png
# https://home-manager-options.extranix.com/?query=hyprlock&release=release-25.11
# https://ghostty.org/
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/core/user.nix?ref_type=heads
# https://wearewaylandnow.com/
