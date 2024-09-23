{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  symlinkJoin,
}: let
  version = "1.7.4";

  src = fetchurl {
    url = "https://github.com/ente-io/photos-desktop/releases/download/v${version}/ente-${version}-x86_64.AppImage";
    sha256 = "0mj0ag8gi5yb77h89bzhm4yc7xj9pixygj5lkbd3d0p60p8xqxg8";
  };

  # Extract the appimage first so we can get the icon inside
  # for the desktop item
  extracted = appimageTools.extract {
    inherit src;
    name = "ente-desktop";
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
