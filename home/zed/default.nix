{ ... }:
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "git-firefly"
      "html"
      "css-modules-kit"
      "scss"
      "dockerfile"
      "nix"
      "prisma"
      "react-typescript-snippets"
      "biome"
      "deno"
      "nu"
      "csv"
      "docker-compose"
      "terraform"
      "opentofu"
      "github-theme"
      "github-actions"
      "dracula"
      # MCP Servers
      "postgres-context-server"
      "prisma-mcp"
      "mcp-server-sequential-thinking"
      "mcp-server-mui"
      "mcp-server-nextjs"
    ];

    mutableUserDebug = false;
    mutableUserKeymaps = false;
    mutableUserSettings = false;
    mutableUserTasks = false;

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          ctrl-shift-t = "workspace::NewTerminal";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          ctrl-shift-enter = "editor::NewlineAbove";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          ctrl-enter = "editor::NewlineBelow";
        };
      }
      {
        context = "Editor";
        bindings = {
          ctrl-d = "editor::DeleteLine";
        };
      }
    ];

    userSettings = {
      telemetry = {
        metrics = false;
      };
      vim_mode = false;
      ui_font_size = 16;
      buffer_font_size = 14;
      tab_size = 2;
      base_keymap = "VSCode";
      buffer_font_family = "FiraCode Nerd Font";
      format_on_save = "on";
      icon_theme = {
        mode = "system";
        dark = "Material Icon Theme";
        light = "Material Icon Theme";
      };
      theme = {
        mode = "system";
        dark = "GitHub Dark Dimmed";
        light = "Nord Light";
      };

      terminal = {
        font_family = "FiraCode Nerd Font Mono";
      };

      jsx_tag_auto_close = {
        enabled = true;
      };

      languages = {
        TypeScript = {
          document_symbols = "on";
        };
      };

      project_panel = {
        dock = "left";
      };

      lsp = {
        biome = {
          settings = {
            require_config_file = true;
          };
        };
      };

      agent = {
        dock = "right";
        sidebar_side = "right";
        default_model = {
          provider = "ollama";
          model = "qwen2.5-coder:7b";
          enable_thinking = false;
        };
        favorite_models = [ ];
        model_parameters = [ ];
      };
      edit_predictions = {
        ollama = {
          model = "qwen2.5-coder:7b";
        };
        provider = "ollama";
      };
      agent_servers = {
        gemini = {
          type = "registry";
        };
      };
      language_models = {
        ollama = {
          api_url = "http://localhost:11434";
        };
      };
    };

    userTasks = [
      {
        label = "Format Code";
        command = "nix";
        args = [
          "fmt"
          "$ZED_WORKTREE_ROOT"
        ];
      }
    ];
  };
}
