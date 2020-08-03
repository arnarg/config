{ stdenv, fetchFromGitHub, pkgconfig, pango, cairo, wayland, wayland-protocols, libxkbcommon }:

stdenv.mkDerivation rec {
  name = "bemenu";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "bemenu";
    rev = version;
    sha256 = "1ifq5bk7782b9m6bl111x33fn38rpppdrww7hfavqia9a9gi2sl5";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "clients" "wayland" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ pango cairo wayland wayland-protocols libxkbcommon ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A dynamic menu library and client program inspired by dmenu";
    homepage = src.meta.homepage;
    license = with licenses; [ gpl3 lgpl3 ];
    platforms = platforms.linux;
  };
}
