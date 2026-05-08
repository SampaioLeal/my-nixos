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
      features = {
        copilot = true;
        edit_predictions = {
          provider = "copilot";
        };
      };
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
        Typescript = {
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
