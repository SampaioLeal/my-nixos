{
  config,
  inputs,
  pkgs,
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
      package = pkgs.btop-cuda;
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

    gemini-cli = {
      enable = true;
      settings = {
        general = {
          previewFeatures = true;
        };
        security = {
          auth = {
            selectedType = "oauth-personal";
          };
        };
      };
      # commands = {
      #   changelog = {
      #     prompt =
      #       ''
      #       Your task is to parse the `<version>`, `<change_type>`, and `<message>` from their input and use the `write_file` tool to correctly update the `CHANGELOG.md` file.
      #       '';
      #     description = "Adds a new entry to the project's CHANGELOG.md file.";
      #   };
      #   "git/fix" = { Becomes /git:fix
      #     prompt = "Please analyze the staged git changes and provide a code fix for the issue described here: {{args}}.";
      #     description = "Generates a fix for a given GitHub issue.";
      #   };
      # };
    };

    opencode = {
      enable = true;
      tui = {
        theme = "github";
      };
      settings = {
        provider = {
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama (local)";
            options = {
              baseURL = "http://localhost:11434/v1";
            };
            models = {
              "qwen2.5-coder:1.5b" = {
                name = "Qwen (small)";
                description = "A smaller version of Qwen, optimized for faster inference.";
              };
              "qwen2.5-coder:7b" = {
                name = "Qwen (local)";
                description = "A large language model based on the Qwen architecture.";
              };
              "gemma4:e2b" = {
                name = "Gemma 4 E2B";
              };
               "gemma4:e4b" = {
                name = "Gemma 4 E4B";
              };
            };
          };
        };
        model = "gemma4:e4b";
        small_model = "qwen2.5-coder:1.5b";
      };
    };
  };
}
