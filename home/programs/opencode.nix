{
  pkgs,
  config,
  inputs,
  ...
}:
let
  cavemanPlugin = pkgs.runCommand "caveman-opencode-plugin" { } ''
    mkdir -p $out
    cp ${inputs.caveman}/src/plugins/opencode/plugin.js $out/
    cp ${inputs.caveman}/src/plugins/opencode/package.json $out/
    cp ${inputs.caveman}/src/hooks/caveman-config.js $out/caveman-config.cjs
  '';
in
{
  programs.opencode = {
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
      small_model = "qwen2.5-coder:7b";
      plugin = [ "superpowers@git+https://github.com/obra/superpowers.git" ];
    };
  };

  #
  # Caveman Plugin
  #
  xdg.configFile."opencode/plugins/caveman" = {
    source = cavemanPlugin;
    recursive = true;
  };

  home.file."${config.xdg.configHome}/opencode/commands/caveman.md".source =
    "${inputs.caveman}/src/plugins/opencode/commands/caveman.md";
  home.file."${config.xdg.configHome}/opencode/commands/caveman-commit.md".source =
    "${inputs.caveman}/src/plugins/opencode/commands/caveman-commit.md";
  home.file."${config.xdg.configHome}/opencode/commands/caveman-help.md".source =
    "${inputs.caveman}/src/plugins/opencode/commands/caveman-help.md";
  home.file."${config.xdg.configHome}/opencode/commands/caveman-review.md".source =
    "${inputs.caveman}/src/plugins/opencode/commands/caveman-review.md";
  home.file."${config.xdg.configHome}/opencode/commands/caveman-stats.md".source =
    "${inputs.caveman}/src/plugins/opencode/commands/caveman-stats.md";
}
