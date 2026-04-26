{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;

    extensions = [ ];

    userKeymaps = [ ];
    userSettings = { };
    userTasks = [ ];
  };
}
