{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.vscode.profiles.default.userSettings = {
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
    "workbench.preferredDarkColorTheme" = "Dracula Theme";
    "workbench.editor.empty.hint" = "hidden";
    "workbench.secondarySideBar.defaultVisibility" = "hidden";

    "git.enableSmartCommit" = true;
    "git.confirmSync" = false;
    "git.autofetch" = true;
    "git.ignoreRebaseWarning" = true;
    "git.replaceTagsWhenPull" = true;
    "git.openRepositoryInParentFolders" = "always";

    "window.autoDetectColorScheme" = false;

    "editor.inlayHints.fontSize" = 8;
    "editor.fontFamily" = "Fira Code";
    "editor.fontLigatures" = true;
    "editor.inlineSuggest.enabled" = true;
    "editor.cursorBlinking" = "expand";
    "editor.bracketPairColorization.enabled" = true;
    "editor.guides.bracketPairs" = "active";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.smoothScrolling" = true;
    "editor.unicodeHighlight.ambiguousCharacters" = false;
    "editor.tabCompletion" = "on";

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
    "json.schemaDownload.trustedDomains" = {
      "https://schemastore.azurewebsites.net/" = true;
      "https://raw.githubusercontent.com/microsoft/vscode/" = true;
      "https://raw.githubusercontent.com/devcontainers/spec/" = true;
      "https://raw.githubusercontent.com/denoland/deno" = true;
      "https://www.schemastore.org/" = true;
      "https://json.schemastore.org/" = true;
      "https://json-schema.org/" = true;
      "https://developer.microsoft.com/json-schemas/" = true;
      "https://biomejs.dev" = true;
    };

    "js/ts.inlayHints.variableTypes.enabled" = true;
    "js/ts.updateImportsOnFileMove.enabled" = "always";
    "js/ts.inlayHints.parameterTypes.enabled" = true;
    "js/ts.inlayHints.enumMemberValues.enabled" = true;
    "js/ts.inlayHints.functionLikeReturnTypes.enabled" = true;
    "js/ts.inlayHints.propertyDeclarationTypes.enabled" = true;
    "js/ts.inlayHints.parameterNames.enabled" = "none";
    "js/ts.implicitProjectConfig.checkJs" = true;

    "diffEditor.codeLens" = true;
    "diffEditor.ignoreTrimWhitespace" = false;

    "terminal.integrated.enableMultiLinePasteWarning" = "never";
    "terminal.integrated.stickyScroll.enabled" = false;
    "terminal.integrated.fontFamily" = "monospace";
    "terminal.integrated.defaultProfile.linux" = "zsh";
    "terminal.integrated.profiles.linux" = {
      "zsh" = {
        "path" = "host-spawn";
        "args" = [
          "zsh"
        ];
      };
    };

    "prisma.hidePrisma6Prompts" = true;

    "githubPullRequests.createOnPublishBranch" = "never";
    "githubPullRequests.pullBranch" = "never";

    "containers.containerClient" = "com.microsoft.visualstudio.containers.docker";

    "biome.suggestInstallingGlobally" = false;

    "github.copilot.enable" = {
      "*" = true;
      "plaintext" = true;
      "markdown" = true;
      "scminput" = false;
      "yaml" = true;
    };
    "github.copilot.chat.codeGeneration.useInstructionFiles" = true;
    "github.copilot.chat.localeOverride" = "pt-br";
    "github.copilot.renameSuggestions.triggerAutomatically" = false;
    "github.copilot.editor.enableCodeActions" = true;
    "github.copilot.nextEditSuggestions.fixes" = true;
    "github.copilot.nextEditSuggestions.enabled" = true;

    "chat.mcp.autostart" = "newAndOutdated";
    "chat.agent.maxRequests" = 100;
    "chat.useAgentsMdFile" = true;

    "[prisma]" = {
      "editor.defaultFormatter" = "Prisma.prisma";
    };
    "[typescript]" = {
      "editor.defaultFormatter" = "vscode.typescript-language-features";
    };
    "[html]" = {
      "editor.defaultFormatter" = "vscode.html-language-features";
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
    "[env]" = {
      "editor.defaultFormatter" = "IronGeek.vscode-env";
    };
    "[jsonc]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };
  };
}
