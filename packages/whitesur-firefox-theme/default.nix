{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "whitesur-firefox-theme";
  version = "2021-12-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-gtk-theme";
    rev = version;
    sha256 = "zIF4jKmPL+sE/0N6NKz4MhYJyxgR0uicQ9cxNllUAUU=";
  };

  patches = [ ./5-extensions.patch ];

  installPhase = ''
    mkdir -p $out
    cp -r src/other/firefox/ $out
    cp -r src/other/firefox/WhiteSur/{icons,titlebuttons} $out/firefox/Monterey
  '';
}
