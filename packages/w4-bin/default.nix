{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "w4-bin";
  version = "2022-03-28";

  src = fetchFromGitHub {
    owner = "w4";
    repo = "bin";
    rev = "9fff1df6e6c7ac327544ac382b595fbff6d4bb47";
    sha256 = "r6Sfq4qPqoJ9y/Gp0/k+yc+6DmKMXKDLKAOCFElZQWY=";
  };

  cargoSha256 = "C4D2TyJQUBxWahhZuJtDravjoIKudpBNolcpAgmON9w=";
}
