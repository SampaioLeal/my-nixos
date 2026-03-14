{
  config,
  inputs,
  ...
}:
{
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      # app = { };
      # appearance = { };
      # themes = [ ];
      # communityPlugins = [ ];
      corePlugins = [
        "backlink"
        "bases"
        "bookmarks"
        "canvas"
        "command-palette"
        "daily-notes"
        "editor-status"
        "file-explorer"
        "file-recovery"
        "global-search"
        "graph"
        "note-composer"
        "outgoing-link"
        "outline"
        "page-preview"
        "switcher"
        "tag-pane"
        "templates"
        "word-count"
      ];
    };
    vaults = {
      personal = {
        enable = true;
        target = "Documents/obisidan-vaults/personal";
      };
      work = {
        enable = true;
        target = "Documents/obisidan-vaults/work";
      };
    };
  };
}
