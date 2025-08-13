{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.5.0";
in
  buildGoModule {
    inherit version;

    pname = "crush";

    src = fetchFromGitHub {
      owner = "charmbracelet";
      repo = "crush";
      rev = "v${version}";
      hash = "sha256-u2w19Xmcm3cx/B8QRNGaP2qeg+Cif/L92RNlJav6H3w=";
    };

    vendorHash = "sha256-H92TgZoWdYQ863AAb2116zJtmgkKXh2hRoEBRcn5zeA=";

    ldflags = [
      "-s"
      "-w"
      "-X 'github.com/charmbracelet/crush/internal/version.Version=${version}'"
    ];

    postInstall = ''
      mkdir -p $out/share/bash-completion/completions
      $out/bin/crush completion bash > $out/share/bash-completion/completions/crush
    '';

    doCheck = false;
  }
