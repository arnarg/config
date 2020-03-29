{ stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "desktop-scripts";
  version = "2020-29-04";

  src = ./src;

  installPhase = ''
    cp -r $src/ $out/
  '';
}
