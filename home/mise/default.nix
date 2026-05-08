{ ... }:
{
  programs.mise = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = {
          version = "24";
          postinstall = "corepack enable";
        };
      };

      env = {
        NODE_ENV = "development";
      }
    };
  };
}