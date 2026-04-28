{ ... }:
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "html"
      "dockerfile"
      "scss"
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
    ];
    userSettings = {
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      vim_mode = false;
      ui_font_size = 16;
      buffer_font_size = 14;
      base_keymap = "VSCode";
      buffer_font_family = "FiraCode";
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
