{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.2.1";
in
  buildGoModule {
    inherit version;
    pname = "ente-cli";

    src = fetchFromGitHub {
      owner = "ente-io";
      repo = "ente";
      rev = "cli-v${version}";
      sha256 = "sha256-ldySZGUfwE+0Tn2unPoS5PtxccmYGB0KNgGcZiRH7pE=";
    };

    vendorHash = "sha256-Gg1mifMVt6Ma8yQ/t0R5nf6NXbzLZBpuZrYsW48p0mw=";

    modRoot = "./cli";

    # Fix binary name
    postInstall = ''
      mv $out/bin/cli $out/bin/ente
    '';
  }
