{ pkgs, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    vim
    nano

    libnotify
  ];
  environment.sessionVariables = {
    # Default applications
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "warp-terminal";
    BROWSER = "zen";

    # XDG Base Directories
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_SCREENSHOTS_DIR = "$HOME/Imagens/Capturas de Tela";

    # Localization
    LC_ALL = "pt_BR.UTF-8";

    # Path modifications - now as a string
    # PATH = "$HOME/.local/bin:$HOME/go/bin:$PATH";
  };

  time.timeZone = "America/Sao_Paulo";
  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  console.keyMap = "pt";

  system.autoUpgrade.enable = true;
  system.stateVersion = "25.11";
}