{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.6.1";
in
  buildGoModule {
    inherit version;

    pname = "crush";

    src = fetchFromGitHub {
      owner = "charmbracelet";
      repo = "crush";
      rev = "v${version}";
      hash = "sha256-QUYNJ2Ifny9Zj9YVQHcH80E2qa4clWVg2T075IEWujM=";
    };

    vendorHash = "sha256-vdzAVVGr7uTW/A/I8TcYW189E3960SCIqatu7Kb60hg=";

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
