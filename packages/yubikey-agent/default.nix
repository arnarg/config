{ buildGoModule, go, lib, fetchFromGitHub, pcsclite, ... }:

buildGoModule rec {
  name = "yubikey-agent";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "yubikey-agent";
    rev = "v${version}";
    sha256 = "0jalcxrhvn65p11ph07yhh8hl0q5w9aq6xp7b60gnwlyifrzyqvg";
  };

  vendorSha256 = "14l27adbnhqdc0kdjkmqplc4yq0jdz9dfv3mj21mfjxib5nx0rzl";

  buildInputs = [ pcsclite ];

  # piv-go hardcodes "-I/usr/include/PCSC"
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
