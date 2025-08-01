{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.1.10";
in
  buildGoModule {
    inherit version;

    pname = "crush";

    src = fetchFromGitHub {
      owner = "charmbracelet";
      repo = "crush";
      rev = "v${version}";
      hash = "sha256-XHdudkll+NUksT+Rdvx3M8SKDpgx4z7M14gIWAY6/hI=";
    };

    vendorHash = "sha256-P+2m3RogxqSo53vGXxLO4sLF5EVsG66WJw3Bb9+rvT8=";

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
