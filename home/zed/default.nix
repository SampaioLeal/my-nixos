{ pkgs, ... }:
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

    userKeymaps = [ ];
    userSettings = { };
    userTasks = [ ];
  };
}
