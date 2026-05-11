{ ... }:
{
  services = {
    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;

    ollama = {
      enable = true;
      host = "127.0.0.1";
      port = 11434;
      syncModels = true;
      loadModels = [
        "gemma4:e2b"
        # Best for: Front‑end development with UI screenshots, debugging from error screenshots, working with architecture diagrams, and any workflow that benefits from a model that sees images.
        # "gemma3:4b"
        # "granite4.1:3b"
        "qwen2.5-coder:1.5b"
        # Best for: Tab autocomplete via Continue.dev, generating boilerplate, explaining code snippets, writing unit tests, and function completion across multiple programming languages.
        "qwen2.5-coder:7b"
        # Best for: General-purpose coding assistance, debugging, refactoring, code explanation, and long-context tasks where you need to pass multiple files in a single prompt.
        # "qwen3.5:9b"
        # Best for: Developers who want a single model that handles coding tasks alongside writing, documentation, Q&A, and general development work without switching between models.
        # "llama3.1:8b"
      ];
    };
  };
}
