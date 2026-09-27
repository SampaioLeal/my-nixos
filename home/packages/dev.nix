{ pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.nil
    pkgs.nixd
    pkgs.nixfmt
    pkgs.entr
    pkgs.bruno
    pkgs.bruno-cli
    pkgs.gping
    pkgs.hyperfine
    pkgs.pastel
    pkgs.scooter
    pkgs.tokei
    pkgs.openssl
    pkgs.git-graph
    pkgs.dnsutils
    pkgs.nmap
    pkgs.rdap
    pkgs.stripe-cli
    pkgs.opentofu
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
    pkgs.opencode-desktop
    pkgs.jetbrains.idea
    inputs.gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
