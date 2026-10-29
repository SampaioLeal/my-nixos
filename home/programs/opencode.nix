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
        "ponytail@git+https://github.com/DietrichGebert/ponytail.git"
      ];
      permissions = [
        {
          action = "shell";
          resource = "*";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "sudo *";
          effect = "deny";
        }
        {
          action = "shell";
          resource = "su *";
          effect = "deny";
        }
        {
          action = "shell";
          resource = "git push *";
          effect = "deny";
        }
        {
          action = "shell";
          resource = "rm -rf *";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "pkill *";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "aws *";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "tofu *";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "terraform *";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "kubectl *";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "git reset --hard*";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "curl *";
          effect = "ask";
        }
        {
          action = "read";
          resource = "*";
          effect = "allow";
        }
        {
          action = "read";
          resource = "*.env";
          effect = "deny";
        }
        {
          action = "read";
          resource = "*.env.*";
          effect = "ask";
        }
        {
          action = "read";
          resource = "*.env.example";
          effect = "allow";
        }
        {
          action = "read";
          resource = "~/.ssh/*";
          effect = "deny";
        }
        {
          action = "read";
          resource = "~/.aws/*";
          effect = "deny";
        }
        {
          action = "read";
          resource = "~/.gnupg/*";
          effect = "deny";
        }
        {
          action = "read";
          resource = "*.pem";
          effect = "deny";
        }
        {
          action = "read";
          resource = "*.key";
          effect = "deny";
        }
        {
          action = "external_directory";
          resource = "*";
          effect = "ask";
        }
      ];
    };
  };
}
