{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.vscode.profiles.sampaiol.userSettings = {
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
}
