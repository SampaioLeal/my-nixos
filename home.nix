{
  lib,
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
    ./home/spotify
    ./home/terminal
    ./home/vscode
    inputs.gazelle.homeModules.gazelle
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
      xournalpp

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
      audacity
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
      libsecret
      bluez
      cava
      libnotify

      # Network
      inputs.gazelle.packages.${pkgs.system}.default
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

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sampaio Leal";
        email = "sampaioleal14@gmail.com";
      };
    };
  };

  programs.btop = {
    enable = true;
  };

  programs.gazelle = {
    enable = true;
    settings = {
      theme = "user-theme";
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

  xdg.mime = {
    enable = true;
    defaultApplications = {
      # Web and HTML
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/chrome" = "zen.desktop";
      "application/x-extension-htm" = "zen.desktop";
      "application/x-extension-html" = "zen.desktop";
      "application/x-extension-shtml" = "zen.desktop";
      "application/x-extension-xht" = "zen.desktop";
      "application/x-extension-xhtml" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";

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
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };
}

# https://github.com/hyprland-community/awesome-hyprland
# https://raw.githubusercontent.com/00Darxk/dotfiles/refs/heads/main/showcases/sayu-showcase.png
# https://home-manager-options.extranix.com/?query=hyprlock&release=release-25.11
# https://ghostty.org/
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/core/user.nix?ref_type=heads
# https://wearewaylandnow.com/
