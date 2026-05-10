{ ... }:
{
  programs.mise = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = {
          version = "lts";
          postinstall = "corepack enable";
        };
        deno = "2";
        python = "3.12";
      };

      settings = {
        idiomatic_version_file_enable_tools = [
          "node"
          "deno"
        ];
      };

      env = {
        NODE_ENV = "development";
      };
    };
  };
}
