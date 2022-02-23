{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "whitesur-kde";
  version = "2022-02-11";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-kde";
    rev = "ec265f9174f0061686151dbb454acc91027a3894";
    sha256 = "wlhYEYstA9QVO/Sqnev3Ndd0YRkSFv7OqcH8Zzzje5Q=";
  };

  installPhase = ''
    mkdir -p $out/share
    cp -r $src/Kvantum $out/share
    cp -r $src/color-schemes $out/share
    mkdir -p $out/share/aurorae/themes
    cp -r $src/aurorae/* $out/share/aurorae/themes
    mkdir -p $out/share/plasma/desktoptheme/WhiteSur{,-alt,-dark}/icons
    cp -r $src/plasma/desktoptheme/WhiteSur* $out/share/plasma/desktoptheme
    cp -r $src/plasma/desktoptheme/icons $out/share/plasma/desktoptheme/WhiteSur{,-alt,-dark}
    mkdir -p $out/share/plasma/look-and-feel
    cp -r $src/plasma/look-and-feel/* $out/share/plasma/look-and-feel/
    mkdir -p $out/share/wallpapers
    cp -r $src/wallpaper/WhiteSur $out/share/wallpapers
  '';
}
