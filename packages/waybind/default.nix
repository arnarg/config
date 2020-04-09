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

  modSha256 = "1inghia2dx3jqw3vy6pqamq1ppgfzlvyf235s8j0m6x56c5r9q2i";

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
