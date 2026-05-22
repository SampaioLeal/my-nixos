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
      };

      settings = {
        os = "linux";
        arch = "x86_64";
        all_compile = false;
        idiomatic_version_file_enable_tools = [
          "node"
          "deno"
        ];
      };

      # env = {
      #   NODE_ENV = "development";
      # };
    };
  };
}
