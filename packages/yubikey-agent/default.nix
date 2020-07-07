{ buildGoModule, go, lib, fetchFromGitHub, pinentry-qt, pcsclite, makeWrapper, ... }:

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

  buildInputs = [ pcsclite makeWrapper ];

  # piv-go hardcodes "-I/usr/include/PCSC"
  preBuild = ''
    export CGO_CFLAGS+="-I${pcsclite.dev}/include/PCSC"
  '';

  postFixup = ''
    wrapProgram $out/bin/yubikey-agent --prefix PATH : ${lib.makeBinPath [ pinentry-qt ]}
  '';

  meta = with lib; {
    description = "yubikey-agent is a seamless ssh-agent for YubiKeys.";
    homepage = https://github.com/FiloSottile/yubikey-agent;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
