{ buildGoModule, go, lib, fetchFromGitHub, libevdev, ... }:

buildGoModule rec {
  pname = "waybind";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "arnarg";
    repo = "waybind";
    rev = "v${version}";
    sha256 = "1zdralbcs47isfb69665hciir5pjzbbg9x2mgc9hbvl30w9dfrz0";
  };

  vendorSha256 = null;

  subPackages = [ "src" ];

  buildInputs = [ libevdev ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp $src/udev/99-uinput.rules $out/lib/udev/rules.d
    mv $out/bin/src $out/bin/waybind
  '';

  meta = with lib; {
    description = "Dead simple keyboard rebinder for wayland based on uinput.";
    homepage = https://github.com/arnarg/waybind;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
