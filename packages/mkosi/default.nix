{ python37Packages, fetchFromGitHub, gnutar, debootstrap, glibc, makeWrapper, ... }:
let
  pythonPackages = python37Packages;
  buildPythonPackage = pythonPackages.buildPythonPackage;
in buildPythonPackage rec {
  pname = "mkosi";
  version = "2020-06-16";

  buildInputs = with pythonPackages; [ pytest ];

  patches = [ ./tar_path.patch ];

  postFixup = ''
    wrapProgram $out/bin/mkosi \
      --set LD_LIBRARY_PATH "${glibc}/lib" \
      --prefix PATH ":" "${debootstrap}/bin:${gnutar}/bin"
  '';

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "1d6d1377eba173c142be491ce2dfb09fb4b6639c";
    sha256 = "1jh304d3rfdfrpgxc7r81zjs7baziyvqiq4scf3ycsnvwi83n3y2";
  };
}
