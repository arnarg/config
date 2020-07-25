{ stdenv }:

stdenv.mkDerivation rec {
  pname = "desktop-scripts";
  version = "2020-07-25";

  src = ./src;

  installPhase = ''
    cp -r $src/ $out/
  '';
}
