{ stdenv, fetchFromGitHub, go-md2man, ... }:

stdenv.mkDerivation rec {
  pname = "nsh";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "mikhailnov";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wv4y7vq7d8vnq1by0ac54h87v01n3aws18677rhzi8xj61kl85k";
  };

  buildInputs = [ go-md2man ];

  postPatch = ''
    sed -i 's/md2man/go-md2man/g' Makefile
    sed -i 's/-output/-out/g' Makefile
  '';

  preBuild = ''
    export DESTDIR=$out
    export PREFIX=""
  '';
}
