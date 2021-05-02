{ lib, stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "tela-icon-theme";
  version = "2021-01-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "8KZFh032+rr7LnYyiM3Bw9YAUsGAZTPTeUxigRXx8D4=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  installPhase = ''
    mkdir -p $out/share/icons
    bash install.sh -d $out/share/icons standard
  '';

  dontDropIconThemeCache = true;

  postFixup = "gtk-update-icon-cache $out/share/icons/Tela";

  meta = with lib; {
    description = "Arc icon theme";
    homepage = "https://github.com/horst3180/arc-icon-theme";
    license = licenses.gpl3;
    # moka-icon-theme dependency is restricted to linux
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
