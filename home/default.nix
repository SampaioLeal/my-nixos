{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./ags
    ./browser
    ./gaming
    ./hyprland
    ./mise
    ./programs
    ./quickshell
    ./spotify
    ./terminal
    ./vscode
    ./zed
    ./packages/dev.nix
    ./packages/media.nix
    ./packages/sys-utils.nix
  ];

  home = {
    username = "sampaiol";
    homeDirectory = "/home/sampaiol";
    stateVersion = "26.05";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      TERMINAL = "ghostty";
      BROWSER = "zen";
      EDITOR = "code";
      VISUAL = "code";
    };

    # Pacotes em home/packages/{dev,media,sys-utils}.nix (Item 15)

    pointerCursor = {
      package = pkgs.bibata-cursors;
      enable = true;
      name = "Bibata-Modern-Classic";
      size = 24;
      hyprcursor = {
        enable = true;
        size = 24;
      };
    };
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

  # services.polkit-gnome = {
  #   enable = true;
  # };

  xdg = {
    enable = true;
    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;
      associations.added = {
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "image/*" = [ "imv.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
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
# https://home-manager-options.extranix.com/?query=hyprlock&release=release-26.05
# https://ghostty.org/
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/core/user.nix?ref_type=heads
# https://wearewaylandnow.com/
