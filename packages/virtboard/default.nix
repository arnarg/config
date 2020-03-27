{ stdenv, fetchgit, meson, cmake, pkgconfig, wayland, wayland-protocols, libxkbcommon, cairo, ninja, gsettings-desktop-schemas, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "virtboard";
  version = "0.0.6";

  src = fetchgit {
    url = "https://source.puri.sm/Librem5/virtboard.git";
    rev = "v${version}";
    sha256 = "09wvsr4ddfajcbp2ipnh8j7pwfclgvlynfi4kwnlpk3571b00fxs";
  };

  nativeBuildInputs = [ meson cmake pkgconfig ninja ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gsettings-desktop-schemas makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/virtboard \
      --set GSETTINGS_SCHEMA_DIR "${gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${gsettings-desktop-schemas.version}/glib-2.0/schemas"
  '';

  meta = with stdenv.lib; {
    description = "A basic keyboard, blazing the path of modern Wayland keyboards. Sacrificial.";
    homepage = "https://source.puri.sm/Librem5/virtboard";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
