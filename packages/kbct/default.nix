{ lib, rustPlatform, fetchFromGitHub, pkgconfig, libudev }:

rustPlatform.buildRustPackage rec {
  pname = "kbct";
  version = "v0.1.0";

  src = fetchFromGitHub {
    owner = "samvel1024";
    repo = "kbct";
    rev = version;
    sha256 = "fWGPNqurWRQead0Qc3xXNQRerJ+O1gmcW9a+KmPvWfM=";
  };

  cargoSha256 = "sha256-5svepqv2766gfdB72Rzprud7F3dznLxfSn6nxQpM9RM=";

  buildInputs = [libudev];
  nativeBuildInputs = [pkgconfig];
}
