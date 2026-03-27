{
  config,
  inputs,
  ...
}:
{
  imports = [
    ./eza.nix
    ./obsidian.nix
    inputs.gazelle.homeModules.gazelle
  ];

  programs = {
    gazelle = {
      enable = true;
      settings = {
        theme = "user-theme";
      };
    };

    btop = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    fd = {
      enable = true;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      shellWrapperName = "y";
      # settings = {};
      # theme = {};
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      # colors = { };
      # defaultOptions = [ ];
    };

    ripgrep = {
      enable = true;
      # arguments = [ ];
    };

    jq = {
      enable = true;
      # colors = {};
    };

    zathura = {
      enable = true;
      # options = {};
    };

    fastfetch = {
      enable = true;
      # settings = { };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Sampaio Leal";
          email = "sampaioleal14@gmail.com";
        };
      };
    };

    gh = {
      enable = true;
      # extensions = [ ];
      hosts = {
        "github.com" = {
          user = "SampaioLeal";
        };
      };
      settings = {
        git_protocol = "ssh";
        aliases = {
          # co = "pr checkout";
          # pv = "pr view";
        };
      };
    };

    lazygit = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      # settings = {};
    };

    lazydocker = {
      enable = true;
      # settings = {};
    };

    asciinema = {
      enable = true;
      settings = { };
    };

    imv = {
      enable = true;
      # settings = {};
    };

    mpv = {
      enable = true;
      # config = {};
    };

    discord = {
      enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
      };
    };

    obs-studio = {
      enable = true;
      # plugins = [ ];
    };

    swappy = {
      enable = true;
      settings = {
        Default = {
          auto_save = false;
          custom_color = "rgba(193,125,17,1)";
          early_exit = false;
          fill_shape = false;
          line_size = 5;
          paint_mode = "brush";
          save_dir = "$HOME/Pictures/Screenshots";
          save_filename_format = "swappy-%Y%m%d-%H%M%S.png";
          show_panel = false;
          text_font = "sans-serif";
          text_size = 20;
          transparency = 50;
          transparent = false;
        };
      };
    };

    cava = {
      enable = true;
      settings = {
        general.framerate = 60;
        smoothing.noise_reduction = 88;
        color = {
          foreground = "'#FFFFFF'";
        };
      };
    };

    #
    # Hyprland Ecosystem
    #

    hyprlock = {
      enable = true;
    };

    hyprshot = {
      enable = true;
      saveLocation = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };
}
