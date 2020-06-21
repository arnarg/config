{ python37Packages, fetchFromGitHub, ... }:
let
  pythonPackages = python37Packages;
  buildPythonPackage = pythonPackages.buildPythonPackage;
in buildPythonPackage rec {
  pname = "mkosi";
  version = "5";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "v${version}";
    sha256 = "05n3bjh1bffhjv582rzbig6bn1y4hzh8sppxrqas3gvp05nig39p";
  };
}
