{ lib, rustPlatform, fetchFromGitHub, pkgconfig, libudev }:

rustPlatform.buildRustPackage rec {
  pname = "kbct";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "samvel1024";
    repo = "kbct";
    rev = version;
    sha256 = "fWGPNqurWRQead0Qc3xXNQRerJ+O1gmcW9a+KmPvWfM=";
  };

  cargoSha256 = "sha256-uBbJeu5NxvgY929Gq1XgimdpdocmhzJ8m7uend92TUM=";

  buildInputs = [libudev];
  nativeBuildInputs = [pkgconfig];
}
