{ pkgs, config, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = false; # evita duplicar com optimise.automatic
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "weekly"; # era daily — weekly basta com 7d de retenção
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    vim
    nano
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.noto
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    font-awesome
    roboto
    inter
    material-icons
  ];

  environment.sessionVariables = {
    # XDG Base Directories
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
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

  console.keyMap = "br-abnt2";

  # Updates manuais via rebuild — autoUpgrade desabilitado (Item 11)
  system.stateVersion = "26.05";
}
