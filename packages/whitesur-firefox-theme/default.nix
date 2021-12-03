{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "whitesur-firefox-theme";
  version = "2021-10-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-gtk-theme";
    rev = version;
    sha256 = "FyIoQbYgUjmdQWn6R1jbX75ExnUCA8DnIUa1Jb5xfOU=";
  };

  patches = [ ./5-extensions.patch ];

  installPhase = ''
    mkdir -p $out
    cp -r src/other/firefox/ $out
    cp -r src/other/firefox/WhiteSur/{icons,titlebuttons} $out/firefox/Monterey
  '';
}
