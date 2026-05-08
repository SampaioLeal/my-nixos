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
          corepack = true;
          postinstall = "corepack enable";
        };
        deno = "2";
      };

      idiomatic_version_file_enable_tools = [
        "node"
        "deno"
      ];

      env = {
        NODE_ENV = "development";
      };
    };
  };
}