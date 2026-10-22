{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.tui-center.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
