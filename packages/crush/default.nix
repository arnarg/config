{
  stdenv,
  fetchzip,
  ...
}: let
  version = "0.7.9";

  bin = fetchzip {
    url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush_${version}_Linux_x86_64.tar.gz";
    hash = "sha256-bWtVMIluLyPgDk0ccWSP2Wqg8TZvapx/FCZy/vQMO4Y=";
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
