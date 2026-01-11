{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    shellAliases = {
      grep = "rg";
      cat = "bat";
      ping = "gping";
      find = "fd";
      ls = "eza";
    };

    initContent =
      let
        # zshConfigEarlyInit = lib.mkOrder 500 ''
        # '';
        zshConfig = lib.mkOrder 1000 ''
          bindkey '^[[1;5C' emacs-forward-word
          bindkey '^[[1;5D' emacs-backward-word
          bindkey '^H' backward-kill-word
          bindkey '^[[3;5~' kill-word
        '';
      in
      lib.mkMerge [
        # zshConfigEarlyInit
        zshConfig
      ];

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
      ];
    };
  };
}
