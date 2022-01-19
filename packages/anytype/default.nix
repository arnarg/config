{ lib, stdenv, fetchurl, appimageTools, makeDesktopItem, symlinkJoin }:
let
  version = "0.23.5";

  extracted = appimageTools.extract {
    name = "anytype2";
    src = fetchurl {
      url = "https://at9412003.fra1.cdn.digitaloceanspaces.com/Anytype-${version}.AppImage";
      sha256 = "0lwia8zdyplwylr2zlnyy5qlhhassjf1s8xzp8nh68pc88bkylwi";
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
