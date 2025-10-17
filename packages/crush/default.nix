{
  stdenv,
  fetchzip,
  ...
}:
let
  version = "0.11.2";

  bin = fetchzip {
    url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush_${version}_Linux_x86_64.tar.gz";
    hash = "sha256-NrubhF0EL0cMv/6+MiW8qdJz/Nhjb4JzBUmMSEkmFt4=";
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
