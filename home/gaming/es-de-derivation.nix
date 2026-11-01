{ pkgs, ... }: let
  pname = "emulationstation-de";
  version = "3.5.0";

  src = pkgs.fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/357718352/download";
    hash = "sha256-q8KZmhI4X4V3W9P5hvqJHHa2nfN5H3wS5MeDzzw2MPU=";
  };
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/usr/share/applications/org.es_de.frontend.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/org.es_de.frontend.desktop \
          --replace 'Exec=es-de' 'Exec=${pname}'
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