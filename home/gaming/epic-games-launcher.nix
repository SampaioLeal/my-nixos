# Epic Games Launcher official Linux client, based on NixOS/nixpkgs#574139.
#
# The public link always redirects to the latest versioned build:
# https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher-x86_64.AppImage
# Older builds are deleted, so version/build/hash must be updated together.
{ pkgs, ... }:
let
  pname = "epic-games-launcher";
  version = "0.120.0";
  build = "gc4bf6af";

  src = pkgs.fetchurl {
    url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${version}%2B${build}/Linux/EpicGamesLauncher-x86_64.AppImage";
    hash = "sha256-pATU4C4vlc0TAqN6/KrhtpB6lvFX0ljQgIYxfVJTorg=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };

  # Only Epic's binary and the EOS SDK come from the AppImage, all other
  # libraries from nixpkgs. The EOS SDK can't be packaged separately, as it's
  # only downloadable behind a login.
  unwrapped = pkgs.stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    src = appimageContents;

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      wrapGAppsHook3
    ];

    buildInputs =
      with pkgs;
      [
        webkitgtk_4_1
        libsoup_3
        gtk3
        glib
        glib-networking
        cairo
        gdk-pixbuf
        libx11
        dbus
        gsettings-desktop-schemas
        stdenv.cc.cc.lib
      ]
      ++ (with gst_all_1; [
        gst-plugins-base
        gst-plugins-good
        gst-plugins-bad
        gst-libav
      ]);

    # Loaded with dlopen
    runtimeDependencies = with pkgs; [
      libayatana-appindicator
      libGL
      libxi
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 usr/bin/EpicGamesLauncher -t $out/bin
      install -Dm755 usr/lib/libEOSSDK-Linux-Shipping.so -t $out/lib
      cp -r usr/lib/epic-games-launcher $out/lib/

      runHook postInstall
    '';
  };
in
# Windows games run through GE-Proton, which the launcher downloads itself.
# Its `proton` script is `#!/usr/bin/env python3` and needs the same multiarch
# FHS as Steam, so use Steam's runtime env like `heroic` used to.
pkgs.steam.buildRuntimeEnv {
  inherit pname version;

  extraPkgs =
    pkgs:
    with pkgs;
    [
      python3
      xrandr
      gamemode
      mangohud
      SDL2
      libxcomposite
      libxxf86vm
      libgcrypt
    ];

  extraEnv = {
    EGL_DISABLE_SELF_UPDATE = "1";
  };

  runScript = "${unwrapped}/bin/EpicGamesLauncher";

  privateTmp = false;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/usr/share/applications/epic-games-launcher.desktop \
      -t $out/share/applications
    substituteInPlace $out/share/applications/epic-games-launcher.desktop \
      --replace-fail 'Exec=EpicGamesLauncher' 'Exec=epic-games-launcher'

    for size in 32x32 128x128 256x256@2; do
      install -Dm444 ${appimageContents}/usr/share/icons/hicolor/$size/apps/EpicGamesLauncher.png \
        -t $out/share/icons/hicolor/$size/apps
    done
  '';

  passthru = {
    inherit src unwrapped;
  };

  meta = {
    description = "Desktop client for the Epic Games Store";
    homepage = "https://launcher.epicgames.com/";
    license = pkgs.lib.licenses.unfree;
    mainProgram = "epic-games-launcher";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with pkgs.lib.sourceTypes; [ binaryNativeCode ];
  };
}
