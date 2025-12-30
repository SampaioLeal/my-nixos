{ lib, pkgs, ... }:
{
    home = {
        username = "sampaiol";
        homeDirectory = "/home/sampaiol";
        stateVersion = "25.11";

        sessionVariables = {
            NIXOS_OZONE_WL = "1";
        };

        packages = with pkgs; [
            wofi
            waybar
            zathura
            cliphist
            dunst
            jq
            fastfetch
            spotify
            discord
        ];

        file = {
            ".p10k.zsh".source = ./shell/.p10k.zsh;
        };
    };

    programs.kitty.enable = true;

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
                src = ./shell;
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

    programs.git = {
        enable = true;
        userName = "Sampaio Leal";
        userEmail = "sampaioleal14@gmail.com";
    };

    programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
            dracula-theme.theme-dracula
        ];
    };

    wayland.windowManager.hyprland = {
        enable = true;
        plugins = [
            pkgs.hyprlandPlugins.hypr-dynamic-cursors
        ];
        settings = {};
    };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
        "$mod" = "SUPER";
        bind =
        [
            "$mod, F, exec, firefox"
            ", Print, exec, grimblast copy area"
        ]
        ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (i:
                let ws = i + 1;
                in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
            )
            9)
        );
    };
}