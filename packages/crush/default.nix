{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.2.1";
in
  buildGoModule {
    inherit version;

    pname = "crush";

    src = fetchFromGitHub {
      owner = "charmbracelet";
      repo = "crush";
      rev = "v${version}";
      hash = "sha256-SjrkQFSjJrPNynARE92uKA53hkstIUBSvQbqcYSsnaM=";
    };

    vendorHash = "sha256-aI3MSaQYUOLJxBxwCoVg13HpxK46q6ZITrw1osx5tiE=";

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
