{
  stdenv,
  fetchzip,
  ...
}:
let
  version = "0.11.0";

  bin = fetchzip {
    url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush_${version}_Linux_x86_64.tar.gz";
    hash = "sha256-iJQo8o5xGTwAeHbomDcCC+j1FmF/pdreoy4zSX2TTO0=";
  };
in
stdenv.mkDerivation {
  inherit version;

  pname = "crush";

  src = bin;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/crush $out/bin/crush

    mkdir -p $out/share/bash-completion/completions
    $out/bin/crush completion bash > $out/share/bash-completion/completions/crush
  '';
}
