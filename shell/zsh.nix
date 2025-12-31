{ lib, pkgs, inputs, ... }:
{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        history.size = 10000;
             
        shellAliases = {
            ll = "ls -l";
            update = "sudo nixos-rebuild switch";
        };

        plugins = [
            {
                name = "powerlevel10k-config";
                src = ./p10k;
                file = "p10k.zsh";
            }
        ];

        zplug = {
            enable = true;
            plugins = [
                { name = "zsh-users/zsh-autosuggestions"; }
                { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
            ];
        };
    };
}