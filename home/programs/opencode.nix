{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.opencode = {
    enable = true;

    tui = {
      theme = "system";
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
      plugin = [
        "superpowers@git+https://github.com/obra/superpowers.git"
      ];
    };
  };
}
