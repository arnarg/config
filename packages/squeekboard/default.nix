{ stdenv, rustPlatform, fetchFromGitLab,
meson, ninja, pkgconfig, cargo, rustc, cmake, gnome3, libcroco, libxml2, libxkbcommon, gtk3, pango, cairo, atk, gdk-pixbuf, glib, wayland, wayland-protocols, makeWrapper, gsettings-desktop-schemas, hicolor-icon-theme, ... }:

rustPlatform.buildRustPackage rec {
  pname = "squeekboard";
  version = "1.9.0";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h4w0sn4smmqlw4vn22hzlzq0w2rps1vyhdr2645kqflcjb5qi7s";
  };

  cargoSha256 = "1bndjqz0zhmjkgqw72nnzd5rpz2p9js4m852qa5852zk2wkrsgzx";

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  nativeBuildInputs = [
    meson
    ninja
    cargo
    rustc
    pkgconfig
    cmake
    libxml2.dev
    makeWrapper
  ];

  buildInputs = [
    libxkbcommon
    gtk3
    atk
    pango
    cairo
    gdk-pixbuf
    glib
    gnome3.gnome-desktop
    libcroco
    wayland
    wayland-protocols
  ];

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  postInstall = ''
    cp -r $src/data/{icons,keyboards,langs,popup.ui,squeekboard.gresources.xml,style-Adwaita:dark.css,style.css} $out/share
  '';

  postFixup = ''
    wrapProgram $out/bin/squeekboard \
      --set GSETTINGS_SCHEMA_DIR "${gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${gsettings-desktop-schemas.version}/glib-2.0/schemas"
  '';

  meta = with stdenv.lib; {
    description = "The final Librem5 keyboard";
    homepage = "https://source.puri.sm/Librem5/squeekboard";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
