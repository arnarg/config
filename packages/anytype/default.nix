{ lib, stdenv, fetchurl, appimageTools, makeDesktopItem, symlinkJoin }:
let
  version = "0.25.0";

  extracted = appimageTools.extract {
    name = "anytype2";
    src = fetchurl {
      url = "https://at9412003.fra1.cdn.digitaloceanspaces.com/Anytype-${version}.AppImage";
      sha256 = "0nwm51izyahgqaba0c7kdq4cgb0wribbmw30cmn6qmnsnxj95y3i";
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
    categories = [ "Utility" ];
  };
in symlinkJoin {
  name = "anytype-${version}";
  paths = [
    wrapped
    desktopItem
  ];
}
