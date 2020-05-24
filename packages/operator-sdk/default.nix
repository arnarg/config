{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper, ... }:

buildGoModule rec {
  name = "operator-sdk";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = "operator-sdk";
    rev = "v${version}";
    sha256 = "0q360vzqpxjglv6mh427lz4wvqby1sh7gcv04c0ai6ln392sj319";
  };

  vendorSha256 = "105yd2lhmqwwys9cs33qb7r810rq1gcrkrzgm7fp5mp8j8dg3p8q";

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
