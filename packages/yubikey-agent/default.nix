{ buildGoModule, go, lib, fetchFromGitHub, pcsclite, ... }:

buildGoModule rec {
  name = "yubikey-agent";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "yubikey-agent";
    rev = "v${version}";
    sha256 = "07gix5wrakn4z846zhvl66lzwx58djrfnn6m8v7vc69l9jr3kihr";
  };

  vendorSha256 = "1gn0w557w7cb9xd03sla6r389ncd3ik5bqwnrwzyb2imfpqwz58a";

  buildInputs = [ pcsclite ];

  # piv-go hardcodes "-I/usr/include/PCSC"
  # https://github.com/go-piv/piv-go/blob/v1.5.0/piv/pcsc_unix.go#L24
  preBuild = ''
    export CGO_CFLAGS+="-I${pcsclite.dev}/include/PCSC"
  '';

  meta = with lib; {
    description = "yubikey-agent is a seamless ssh-agent for YubiKeys.";
    homepage = https://github.com/FiloSottile/yubikey-agent;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
