{ lib, stdenv, fetchurl, appimageTools, makeDesktopItem, symlinkJoin }:
let
  version = "0.23.0";

  extracted = appimageTools.extract {
    name = "anytype2";
    src = fetchurl {
      url = "https://at9412003.fra1.cdn.digitaloceanspaces.com/Anytype-${version}.AppImage";
      sha256 = "1k6gp7wcqa6zr6fsl7bqycs8mcs0m8z9dasisln4v7kfrd7z4w77";
    };
  };

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
    categories = "Utility";
  };
in symlinkJoin {
  name = "anytype-${version}";
  paths = [
    wrapped
    desktopItem
  ];
}
