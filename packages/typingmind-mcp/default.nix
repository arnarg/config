{
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "typingmind-mcp";
  version = "2025-06-06";

  src = fetchFromGitHub {
    owner = "typingmind";
    repo = "typingmind-mcp";
    rev = "5a04e8c70e8085ff0dff663c0fd7c12b5d42148e";
    hash = "sha256-QP5thPTF5yAI9Nk+MpCEeBvpB43RlCz+NOHeZMeuw0s=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-52iIOPJCLJc5z8DWIi00ykKzc76JJOV9C0uBXkIHi74=";
  };

  installPhase = ''
    mkdir -p $out/{bin,lib}

    cp -r * $out/lib

    cat <<EOF > $out/bin/typingmind-mcp
    #!/usr/bin/env bash

    ${nodejs}/bin/node $out/lib/bin/index.js
    EOF
    chmod +x $out/bin/typingmind-mcp
  '';
})
