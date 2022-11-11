{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "w4-bin";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "w4";
    repo = "bin";
    rev = "v${version}";
    sha256 = "FruZWHf2PPu3Wn+rgbMg5w9zHwiKS33D0a/24kfjY5E=";
  };

  cargoSha256 = "EY1jIOH8OZaHSEQkD71GDOiRWQOLld86Ys+3g3Ea8Lg=";
}
