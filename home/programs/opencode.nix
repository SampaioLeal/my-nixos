{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.opencode = {
    enable = true;

    cli = {
      theme = "system";
    };

    settings = {
      provider = { };
      plugin = [
        "superpowers@git+https://github.com/obra/superpowers.git"
      ];
    };
  };
}
