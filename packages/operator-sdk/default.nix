{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper, ... }:

buildGoModule rec {
  name = "operator-sdk";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = "operator-sdk";
    rev = "v${version}";
    sha256 = "0cd55dq29ppchbqhrj2aimyplp6wrlyah1kjpbfkf84gab84dw22";
  };

  modSha256 = "0vsh99m6nxqgxjrfb5fj1b5m212qx4m33d9mjj34jiblnky24p4m";

  subPackages = [ "cmd/operator-sdk" ];

    buildInputs = [ go makeWrapper ];

    # operator-sdk uses the go compiler at runtime
    allowGoReference = true;
    postFixup = ''
      wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
    '';

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding.";
    homepage = https://github.com/operator-framework/operator-sdk;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
