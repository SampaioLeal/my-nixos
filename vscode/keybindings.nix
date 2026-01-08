{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.vscode.profiles.sampaiol.keybindings = [
    {
      key = "ctrl+d";
      command = "editor.action.deleteLines";
      when = "textInputFocus && !editorReadonly";
    }
    {
      key = "ctrl+d";
      command = "-editor.action.addSelectionToNextFindMatch";
      when = "editorFocus";
    }
    {
      key = "ctrl+shift+k";
      command = "-editor.action.deleteLines";
      when = "textInputFocus && !editorReadonly";
    }
    {
      key = "ctrl+shift+[BracketLeft]";
      command = "workbench.action.terminal.toggleTerminal";
    }
    {
      key = "ctrl+shift+[BracketLeft]";
      command = "-workbench.action.terminal.toggleTerminal";
      when = "terminal.active";
    }
  ];
}
