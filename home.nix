{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./browser
    ./hyprland
    ./launcher
    ./notifications
    ./spotify
    ./terminal
    ./waybar
  ];

  home = {
    username = "sampaiol";
    homeDirectory = "/home/sampaiol";
    stateVersion = "25.11";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    packages = with pkgs; [
      # CLI Utils
      fastfetch
      moreutils
      ripgrep
      lshw
      appimage-run
      tldr
      fzf
      bat
      asciinema
      asciinema-agg
      progress
      htop
      btop
      lm_sensors
      wl-clipboard
      cliphist
      xdg-utils

      # Developer Tools
      jq
      gh
      lazygit
      lazydocker
      bruno
      bruno-cli
      warp-terminal
      gping
      hyperfine
      pastel
      scooter
      tokei
      openssl
      git-graph
      hyprpicker
      nixfmt
      dnsutils
      nmap
      rdap

      # Multimedia
      lowfi
      zathura
      imv
      mpv
      ffmpeg
      ffmpegthumbnailer
      imagemagick

      # Communication
      discord

      # Productivity and office
      obsidian

      # File management and archives
      fd
      eza
      yazi
      broot
      p7zip
      unzip
      zip
      unrar
      file-roller
      nautilus

      # Disk Management
      ncdu
      duf
      caligula
      udiskie

      # Misc
      obs-studio
      cmatrix
      lolcat
      swappy
      asciiquarium-transparent
      countryfetch
      cowsay
      figlet
      lavat
      bemoji
      gnome-calculator
      polkit_gnome
    ];
  };

  # home.pointerCursor = {
  #   package = pkgs.catppuccin-cursors.mochaPink;
  #   name = "Catppuccin-Mocha-Pink-Cursors";
  #   size = 40;
  #   gtk.enable = true;
  # };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font";
      size = 10;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.sessionVariables.GTK_THEME = "Adwaita-dark";

  qt = {
    enable = true;
    platformTheme = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sampaio Leal";
        email = "sampaioleal14@gmail.com";
      };
    };
  };

  home.file.".vscode/argv.json" = {
    text = ''
      {
        "enable-crash-reporter": true,

        "crash-reporter-id": "2837d826-01c9-4aae-922d-9daffc753f01",

        "password-store":"gnome-libsecret"
      }
    '';
  };

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

      keybindings = [
        {
          key = "ctrl+d";
          command = "-editor.action.addSelectionToNextFindMatch";
          when = "editorFocus";
        }
        {
          key = "ctrl+d";
          command = "editor.action.deleteLines";
          when = "textInputFocus && !editorReadonly";
        }
        {
          key = "ctrl+shift+k";
          command = "-editor.action.deleteLines";
          when = "textInputFocus && !editorReadonly";
        }
      ];

      userSettings = {
        "files.eol" = "\n";
        "files.exclude" = {
          "**/.git" = true;
          "**/.DS_Store" = true;
          "**/node_modules" = true;
        };
        "files.associations" = {
          "*.env" = "env";
        };
        "files.watcherExclude" = {
          "**/.git/objects/**" = true;
          "**/.git/subtree-cache/**" = true;
          "**/node_modules/**" = true;
          "**/env/**" = true;
          "**/venv/**" = true;
          "**/.next/**" = true;
          "**/build/**" = true;
          "**/dist/**" = true;
          "**/.react-router/**" = true;
          "**/.turbo/**" = true;
          "**/.vercel/**" = true;
        };

        "material-icon-theme.files.associations" = {
          "*.handler.ts" = "scheme";
        };
        "material-icon-theme.activeIconPack" = "nest";

        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.list.smoothScrolling" = true;
        "workbench.colorTheme" = "Dracula Theme";
        "workbench.editor.empty.hint" = "hidden";

        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "git.autofetch" = true;
        "git.ignoreRebaseWarning" = true;
        "git.replaceTagsWhenPull" = true;
        "git.openRepositoryInParentFolders" = "always";

        "editor.inlayHints.fontSize" = 8;
        "editor.tabSize" = 2;
        "editor.fontFamily" = "Fira Code";
        "editor.fontLigatures" = true;
        "editor.inlineSuggest.enabled" = true;
        "editor.cursorBlinking" = "expand";
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "editor.unicodeHighlight.ambiguousCharacters" = false;

        "todo-tree.highlights.enabled" = true;
        "todo-tree.general.tags" = [
          "TODO"
          "FIXME"
          "TOTEST"
          "REFACTOR"
          "[ ]"
        ];
        "todo-tree.highlights.customHighlight" = {
          "REFACTOR" = {
            "foreground" = "#eff542";
            "type" = "text";
            "icon" = "alert";
          };
          "TODO" = {
            "foreground" = "#f4a442";
            "type" = "text";
            "icon" = "checklist";
          };
        };

        "json.schemas" = [ ];

        "javascript.updateImportsOnFileMove.enabled" = "always";
        "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
        "javascript.inlayHints.parameterTypes.enabled" = true;
        "javascript.inlayHints.variableTypes.enabled" = true;
        "javascript.inlayHints.propertyDeclarationTypes.enabled" = true;
        "javascript.inlayHints.enumMemberValues.enabled" = true;

        "typescript.updateImportsOnFileMove.enabled" = "always";
        "typescript.inlayHints.parameterTypes.enabled" = true;
        "typescript.inlayHints.enumMemberValues.enabled" = true;
        "typescript.inlayHints.functionLikeReturnTypes.enabled" = true;
        "typescript.inlayHints.propertyDeclarationTypes.enabled" = true;
        "typescript.inlayHints.variableTypes.enabled" = true;
        "typescript.inlayHints.parameterNames.enabled" = "none";

        "js/ts.implicitProjectConfig.checkJs" = true;

        "diffEditor.codeLens" = true;
        "diffEditor.ignoreTrimWhitespace" = false;

        "terminal.integrated.enableMultiLinePasteWarning" = "never";
        "terminal.integrated.stickyScroll.enabled" = false;
        "terminal.external.linuxExec" = "warp-terminal";
        "terminal.integrated.fontFamily" = "monospace";
        "terminal.integrated.defaultProfile.linux" = "bash";
        "terminal.integrated.profiles.linux" = {
          "bash" = {
            "path" = "host-spawn";
            "args" = [
              "bash"
            ];
          };
        };

        "prisma.hidePrisma6Prompts" = true;
        "prisma.showPrismaDataPlatformNotification" = false;

        "settingsSync.ignoredSettings" = [ ];

        "githubPullRequests.createOnPublishBranch" = "never";
        "githubPullRequests.pullBranch" = "never";

        "liveServer.settings.donotShowInfoMsg" = true;

        "svelte.plugin.svelte.note-new-transformation" = false;

        "python.formatting.provider" = "none";

        "jupyter.askForKernelRestart" = false;

        "continue.showInlineTip" = false;

        "docker.extension.dockerEngineAvailabilityPrompt" = false;

        "biome.suggestInstallingGlobally" = false;

        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = true;
          "markdown" = true;
          "scminput" = false;
          "yaml" = true;
        };
        "github.copilot.selectedCompletionModel" = "";
        "github.copilot.chat.codeGeneration.useInstructionFiles" = true;
        "github.copilot.chat.localeOverride" = "pt-br";
        "github.copilot.nextEditSuggestions.fixes" = false;
        "github.copilot.editor.enableCodeActions" = false;
        "github.copilot.chat.copilotDebugCommand.enabled" = false;
        "github.copilot.chat.reviewAgent.enabled" = false;
        "github.copilot.chat.reviewSelection.enabled" = false;
        "github.copilot.chat.startDebugging.enabled" = false;
        "github.copilot.chat.agent.currentEditorContext.enabled" = false;
        "github.copilot.chat.edits.suggestRelatedFilesForTests" = false;
        "github.copilot.chat.edits.suggestRelatedFilesFromGitHistory" = false;
        "github.copilot.chat.setupTests.enabled" = false;
        "github.copilot.chat.summarizeAgentConversationHistory.enabled" = false;
        "github.copilot.renameSuggestions.triggerAutomatically" = false;
        "github.copilot.chat.newWorkspaceCreation.enabled" = false;
        "github.copilot.nextEditSuggestions.enabled" = true;

        "chat.tools.terminal.autoApprove" = {
          "rm" = false;
          "rmdir" = false;
          "del" = false;
          "kill" = false;
          "curl" = false;
          "wget" = false;
          "eval" = false;
          "chmod" = false;
          "chown" = false;
          "/^Remove-Item\\b/i" = false;
          "mkdir" = true;
          "touch" = true;
          "yarn workspace" = true;
          "deno" = true;
          "python balance_dataset.py" = {
            "approve" = true;
            "matchCommandLine" = true;
          };
          "python count_labels.py" = {
            "approve" = true;
            "matchCommandLine" = true;
          };
          "Check" = true;
        };
        "chat.agent.maxRequests" = 100;

        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
        };
        "[prisma]" = {
          "editor.defaultFormatter" = "Prisma.prisma";
        };
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[svelte]" = {
          "editor.defaultFormatter" = "svelte.svelte-vscode";
        };
        "[sass]" = {
          "editor.defaultFormatter" = "syler.sass-indented";
        };
        "[terraform]" = {
          "editor.defaultFormatter" = "hashicorp.terraform";
        };
        "[terraform-vars]" = {
          "editor.defaultFormatter" = "hashicorp.terraform";
        };
        "[xml]" = {
          "editor.defaultFormatter" = "redhat.vscode-xml";
        };
        "[env]" = {
          "editor.defaultFormatter" = "IronGeek.vscode-env";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
      };
    };
  };

  #
  # Hyprland Ecosystem
  #

  programs.hyprlock = {
    enable = true;
  };

  programs.hyprshot = {
    enable = true;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        # {
        #   # monitor backlight restore.
        #   timeout = 150; # 2.5min.
        #   on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
        #   on-resume = "brightnessctl -r";
        # }
        # {
        #   # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        #   timeout = 150; # 2.5min.
        #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
        #   on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        # }
        {
          timeout = 600; # 10min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 900; # 15min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
          # TODO: fix this
          timeout = 3600; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };

  services.hyprsunset = {
    enable = true;
  };

  # xdg.mime = {
  #   enable = true;
  #   defaultApplications = {
  #     "application/pdf" = "org.pwmt.zathura.desktop";
  #     "application/vnd.apple.mpegurl" = "vlc.desktop";
  #     "application/x-extension-htm" = "firefox.desktop";
  #     "application/x-extension-html" = "firefox.desktop";
  #     "application/x-extension-shtml" = "firefox.desktop";
  #     "application/x-extension-xht" = "firefox.desktop";
  #     "application/x-extension-xhtml" = "firefox.desktop";
  #     "application/x-shellscript" = "emacsclient.desktop";
  #     "application/xhtml+xml" = "firefox.desktop";
  #     "audio/x-mpegurl" = "vlc.desktop";
  #     "image/png" = "feh.desktop";
  #     "text/*" = "emacsclient.desktop";
  #     "text/css" = "emacsclient.desktop";
  #     "text/html" = "firefox.desktop";
  #     "text/markdown" = "calibre-ebook-viewer.desktop";
  #     "text/plain" = "emacsclient.desktop";
  #     "video/*" = "umpv.desktop";
  #     "x-scheme-handler/chrome" = "firefox.desktop";
  #     "x-scheme-handler/http" = "firefox.desktop";
  #     "x-scheme-handler/https" = "firefox.desktop";
  #     "x-scheme-handler/mpv" = "open-in-mpv.desktop";
  #   };
  # };
}

# https://github.com/hyprland-community/awesome-hyprland
# https://raw.githubusercontent.com/00Darxk/dotfiles/refs/heads/main/showcases/sayu-showcase.png
# https://github.com/00Darxk/dotfiles/blob/main/waybar/style.css
# https://home-manager-options.extranix.com/?query=hyprlock&release=release-25.11
# https://ghostty.org/
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/core/user.nix?ref_type=heads
# https://wearewaylandnow.com/
