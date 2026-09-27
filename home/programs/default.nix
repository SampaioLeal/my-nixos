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
    ./opencode.nix
    inputs.gazelle.homeModules.gazelle
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };

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
      config = {
        # Base de alta qualidade do libplacebo (define scaler, deband, dither, HDR)
        profile = "high-quality";

        # Renderer moderno + Vulkan (ideal p/ RTX 3060 no Wayland)
        vo = "gpu-next";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";

        # NVDEC com cópia p/ GPU: acelera sem pular scaler/deband/tone-mapping
        # nvdec puro entrega frames opacos e ignora o pipeline de qualidade
        hwdec = "nvdec-copy";
        hwdec-codecs = "all";

        # Upscaling superior ao spline36, sem custo relevante na 3060
        scale = "ewa_lanczossharp";
        cscale = "ewa_lanczos";
        dscale = "mitchell";
        correct-downscaling = "yes";
        linear-downscaling = "yes";
        sigmoid-upscaling = "yes";

        # Anti-banding (visível em degradês/cenas escuras)
        deband = "yes";
        deband-iterations = 4;
        deband-threshold = 48;
        deband-range = 16;
        deband-grain = 48;

        # Dither temporal p/ painel 8-bit (evita banding sem ruído parado)
        dither-depth = "auto";
        temporal-dither = "yes";

        # HDR -> SDR correto + pico por cena
        hdr-compute-peak = "yes";
        tone-mapping = "bt.2390";
        target-colorspace-hint = "yes";
        target-contrast = "auto";
        target-peak = "auto";

        # Sincronia com o display (motion suave, sem judder)
        video-sync = "display-resample";
        interpolation = "yes";
        tscale = "oversample";

        # Mantém proporção da janela
        keepaspect-window = "yes";
      };
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

    antigravity-cli = {
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
  };
}
