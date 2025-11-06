{
  stdenv,
  fetchzip,
  ...
}:
let
  version = "0.15.1";

  bin = fetchzip {
    url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush_${version}_Linux_x86_64.tar.gz";
    hash = "sha256-3LgHfDsxsLpvKnstGkyuJaOYYH1bz4EaFnfGgJ6NGnc=";
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
