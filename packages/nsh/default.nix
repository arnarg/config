{ stdenv, ... }:

stdenv.mkDerivation {
  name = "nsh";

  src = ./src;

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/share
    cp $src/nsh $out/share/nsh
    cp -r $src/shells $out/share/shells
  '';

  postFixup = ''
    substituteInPlace $out/share/nsh --subst-var-by share $out/share
  '';
}
