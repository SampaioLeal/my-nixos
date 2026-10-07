{ pkgs, ... }: let
  pname = "libredb-studio";
  version = "0.18.0";

  src = pkgs.fetchurl {
    url = "https://github.com/libredb/libredb-studio/releases/download/0.18.0/libredb-studio-desktop-0.18.0-linux-x64.AppImage";
    hash = "sha256-gBH42amDWai3DJ+6hLNDB557aYAjHYHKuRBkBioe9X0=";
  };
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/usr/share/applications/libredb-studio-desktop.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/libredb-studio-desktop.desktop \
          --replace 'Exec=libredb-studio-desktop' 'Exec=${pname}'
        cp -r ${appimageContents}/usr/share/icons $out/share
      '';

      extraBwrapArgs = [
        "--bind-try /etc/nixos/ /etc/nixos/"
      ];

      # vscode likes to kill the parent so that the
      # gui application isn't attached to the terminal session
      # dieWithParent = false;

      extraPkgs = pkgs: with pkgs; [
        # unzip
        # autoPatchelfHook
        # asar
        # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
        # (buildPackages.wrapGAppsHook.override {inherit (buildPackages) makeWrapper;})
      ];
    }