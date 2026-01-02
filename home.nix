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
    platformTheme.name = "Adwaita-dark";
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
  };

  services.hyprpolkitagent = {
    enable = true;
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
