{ buildGoModule, lib, fetchFromGitHub, makeWrapper, git, openssh }:

buildGoModule rec {
  pname = "pushnix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "arnarg";
    repo = "pushnix";
    rev = "v${version}";
    sha256 = "1p8v1mpad0lxb3nh4fg2wlyb78ky3745agjsawc4vy2hms41j246";
  };

  vendorSha256 = "1m2pqswhgizi3a3gk9c121ccwli05hh2ha76a9cmgy2gfy293dwh";

  subPackages = [ "." ];

  buildInputs = [ makeWrapper ];

  buildFlagsArray = ''
    -ldflags=
    -X
    main.Version=${version}
  '';

  postFixup = ''
    wrapProgram $out/bin/pushnix \
      --prefix PATH : "${lib.makeBinPath [ git openssh ]}"
  '';

  meta = with lib; {
    description = "Simple cli utility that pushes NixOS configuration and triggers a rebuild using ssh.";
    homepage = https://github.com/arnarg/pushnix;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
