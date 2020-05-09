{ stdenv, buildGoModule, go, lib, fetchzip, fetchFromGitHub, makeWrapper, wireshark, ... }:
let
  version = "1.4.1";
  # This needs to be compiled on a Linux system because it gets copied into containers
  # running in Kubernetes.
  static-tcpdump = stdenv.mkDerivation {
    pname = "static-tcpdump";
    version = version;

    src = fetchzip {
      url = "https://github.com/eldadru/ksniff/releases/download/v${version}/ksniff.zip";
      sha256 = "0kx1zwkcfglfysnxgwliqsy9d4lw51kl3r5pv6izk6lnc47f2lxr";
      stripRoot = false;
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src/static-tcpdump $out/bin/static-tcpdump
    '';
  };
in buildGoModule {
  pname = "ksniff";
  version = version;

  src = fetchFromGitHub {
    owner = "eldadru";
    repo = "ksniff";
    rev = "v${version}";
    sha256 = "0vqx29wsxhv06kwxmcmqixa8g4qxy4zqlyx1icaqhpv0rgddildb";
  };

  modSha256 = "1s6q1r0a3yzzcww3jrlacfpyb9nsyn8n78clahp7n8jhi8fziz7g";

  subPackages = [ "cmd/kubectl-sniff.go" ];

  buildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/kubectl-sniff \
      --set KUBECTL_PLUGINS_LOCAL_FLAG_LOCAL_TCPDUMP_PATH "${static-tcpdump}/bin/static-tcpdump" \
      --prefix PATH ":" "${wireshark}/bin"
  '';

  meta = with lib; {
    description = "Kubectl plugin to ease sniffing on kubernetes pods using tcpdump and wireshark.";
    homepage = https://github.com/eldadru/ksniff;
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
