{ pkgs, ... }:
{
  # home.packages = [ pkgs.nix-ld ];

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      gcc
      gnumake
      pkg-config
      libffi
      zlib
      readline
      openssl
      bzip2
      sqlite
    ];
  };
}
