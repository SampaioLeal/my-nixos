{
  imports = [
    ./keybindings.nix
    ./settings.nix
  ];

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
        opentofu.vscode-opentofu
        mikestead.dotenv
        mhutchie.git-graph
        hashicorp.terraform
        gruntfuggly.todo-tree
        github.vscode-pull-request-github
        github.vscode-github-actions
        denoland.vscode-deno
        biomejs.biome
      ];
    };
  };
}
