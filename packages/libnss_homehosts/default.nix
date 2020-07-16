{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  pname = "libnss_homehosts";
  version = "2020-07-15";

  src = fetchFromGitHub {
    owner = "bAndie91";
    repo = pname;
    rev = "ac0a8a0a0bc4d5b3e102101abc3b714b2f8336df";
    sha256 = "1bwaqmq2637nzchj2aaar61mj96krcqvm0rjd1nsjh9s1qax1hvr";
  };

  makeFlags = [ "INSTALL_FOLDER=$(out)/lib" "VERSION=2" ];

  preInstall = ''
    mkdir -p $out/lib
    sed -i '/ldconfig/d' Makefile
  '';

  postInstall = ''
    chmod +x $out/lib/libnss_homehosts.so
  '';
}
