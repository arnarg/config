{
  fetchurl,
  appimageTools,
  makeDesktopItem,
  symlinkJoin,
}: let
  version = "1.7.10";

  src = fetchurl {
    url = "https://github.com/ente-io/photos-desktop/releases/download/v${version}/ente-${version}-x86_64.AppImage";
    sha256 = "sha256-L2N3saNeJDdji/IzC2Zi0Iixc/pPNSUpz07egywx+4U=";
  };

  # Extract the appimage first so we can get the icon inside
  # for the desktop item
  extracted = appimageTools.extract {
    inherit src version;
    pname = "ente-desktop";
  };

  # Wrap appimage
  wrapped = appimageTools.wrapAppImage {
    name = "ente-desktop";
    src = extracted;
    extraPkgs = pkgs: with pkgs; [libsodium fuse];
  };

  desktopItem = makeDesktopItem {
    name = "ente";
    desktopName = "ente";
    icon = "${extracted}/ente.png";
    comment = "Desktop client for Ente Photos";
    exec = "${wrapped}/bin/ente-desktop";
    categories = ["Photography"];
  };
in
  symlinkJoin {
    name = "ente-desktop-${version}";
    paths = [
      wrapped
      desktopItem
    ];
  }
