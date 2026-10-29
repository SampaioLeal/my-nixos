# https://github.com/openchamber/openchamber/releases/download/v2.5.3/OpenChamber-2.5.3-linux-x86_64.AppImage

{ pkgs, ... }: let
  pname = "openchamber";
  version = "2.5.3";

  src = pkgs.fetchurl {
    url = "https://github.com/openchamber/openchamber/releases/download/v2.5.3/OpenChamber-2.5.3-linux-x86_64.AppImage";
    hash = "sha256-wDSorfUq9bxQ+Z3OmU1wFZdBB00MQmb0VrcPWbyB3jI=";
  };
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/openchamber.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/openchamber.desktop \
          --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
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