{ buildGoModule, lib, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "plex_exporter";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "arnarg";
    repo = "plex_exporter";
    rev = "v${version}";
    sha256 = "011cb04rzg8s8l28j923npq0cin4qlhgl484w9yiqwvc36mxf4vc";
  };

  modSha256 = "0cvqy42brdlx7whhbf2j5kgryzpgz12jdd6vy6v7z3i3z17s7gha";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Rotate Sway outputs based on current accelerometer orientation using iio-sensor-proxy.";
    homepage = https://github.com/arnarg/sway-accel-rotate;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
