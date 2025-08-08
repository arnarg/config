{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.3.0";
in
  buildGoModule {
    inherit version;

    pname = "crush";

    src = fetchFromGitHub {
      owner = "charmbracelet";
      repo = "crush";
      rev = "v${version}";
      hash = "sha256-0FzMNqSG/JjbdvVUaWlnZQvU3E1PWBG8968d3/mg4XE=";
    };

    vendorHash = "sha256-v04C77HvBpIpzZ8ehwwfG9guaE2k40TaSXPK3nahMM0=";

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
