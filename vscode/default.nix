{ pkgs, ... }:
{
  imports = [
    ./keybindings.nix
    ./settings.nix
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;

    profiles.default = {
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
    };

    profiles.sampaiol = {
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        jnoortheen.nix-ide
        pkief.material-icon-theme
        prisma.prisma
        mikestead.dotenv
        mhutchie.git-graph
        hashicorp.terraform
        gruntfuggly.todo-tree
        github.vscode-pull-request-github
        github.vscode-github-actions
        denoland.vscode-deno
        biomejs.biome
        mkhl.direnv
        github.copilot-chat
        ms-azuretools.vscode-containers
      ];
    };
  };

  home.file.".vscode/argv.json" = {
    force = true;
    text = ''
      {
        "enable-crash-reporter": true,
        "crash-reporter-id": "2837d826-01c9-4aae-922d-9daffc753f01",
        "password-store":"gnome-libsecret",
        "locale": "pt-br",
        "enable-wayland-ime": true
      }
    '';
  };
}
