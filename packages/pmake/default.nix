{ stdenv, lib, fetchFromGitHub, fpc, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "pmake";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "daar";
    repo = "pmake";
    rev = "v${version}";
    sha256 = "1q2djfga539l0z54w08rx1i76sz691bk18v74w0zsl9bpr2y1vmy";
  };

  buildInputs = [ fpc makeWrapper ];

  buildPhase = ''
    cd pmake
    ${fpc}/bin/fpc pmake.pp
    ./pmake .
    ./make build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/x86_64-linux/pmake $out/bin/
  '';

  postFixup = ''
    wrapProgram $out/bin/pmake --prefix PATH : ${lib.makeBinPath [ fpc ]}
  '';
}
