{ pkgs, ... }: let
  pname = "emulationstation-de";
  version = "3.4.1";

  src = pkgs.fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/288156961/download";
    hash = "sha256-PGGkTXONVRY9qljt5wcgtCWg32JGDATcI908pYZyNYE=";
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