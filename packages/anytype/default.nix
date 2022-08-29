{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  symlinkJoin,
}: let
  version = "0.27.0";

  # Extract the appimage first so we can get the icon inside
  # for the desktop item
  extracted = appimageTools.extract {
    name = "anytype2";
    src = fetchurl {
      url = "https://at9412003.fra1.cdn.digitaloceanspaces.com/Anytype-${version}.AppImage";
      sha256 = "08yy3z2jxdwxhz8zy3jkvl8pxqqfabix3dwlwfr9dbv7563dgj81";
    };
  };

  # Wrap appimage
  wrapped = appimageTools.wrapAppImage {
    name = "anytype2";
    src = extracted;
    extraPkgs = pkgs: with pkgs; [libsecret];
  };

  desktopItem = makeDesktopItem {
    name = "anytype2";
    desktopName = "anytype2";
    icon = "${extracted}/anytype2.png";
    comment = "operating system for life";
    exec = "${wrapped}/bin/anytype2";
    categories = ["Utility"];
  };
in
  symlinkJoin {
    name = "anytype-${version}";
    paths = [
      wrapped
      desktopItem
    ];
  }
