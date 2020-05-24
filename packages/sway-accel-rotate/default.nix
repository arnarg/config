{ buildGoModule, lib, fetchFromGitHub, makeWrapper, sway, ... }:

buildGoModule rec {
  pname = "sway-accel-rotate";
  version = "2020-31-04";

  src = fetchFromGitHub {
    owner = "arnarg";
    repo = "sway-accel-rotate";
    rev = "master";
    sha256 = "0yyi9s1f5irbmbrafhh3862zkjcjcm8ffr89db14wsvs3a2m3ym4";
  };

  vendorSha256 = "0fvv45659zywqw6xmli80hx113ni3kf5xhq9f01hv4fqb65p43ac";

  subPackages = [ "." ];

  buildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/sway-accel-rotate \
      --prefix PATH : ${lib.makeBinPath [ sway ]}
  '';

  meta = with lib; {
    description = "Rotate Sway outputs based on current accelerometer orientation using iio-sensor-proxy.";
    homepage = https://github.com/arnarg/sway-accel-rotate;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
