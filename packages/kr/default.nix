{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper, ... }:

buildGoModule rec {
  name = "kr";
  version = "2.4.15";

  src = fetchFromGitHub {
    owner = "kryptco";
    repo = "kr";
    rev = "1937e31606e4dc0f7263133334d429f956502276";
    sha256 = "13ch85f1y4j2n4dbc6alsxbxfd6xnidwi2clibssk5srkz3mx794";
  };

  modSha256 = "1q6vhdwz26qkpzmsnk6d9j6hjgliwkgma50mq7w2rl6rkwashvay";

  modRoot = "src";

  subPackages = [ "kr" "krd" "krgpg" "krssh" ];

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding.";
    homepage = https://github.com/operator-framework/operator-sdk;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
