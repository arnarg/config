{ stdenv, rustPlatform, fetchFromGitLab,
  meson, ninja, cargo, rustc, pkgconfig, cmake, glib, libxml2, wrapGAppsHook,
  gnome3, gtk3, libcroco, libxkbcommon, wayland, wayland-protocols, ... }:

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
    glib
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.adwaita-icon-theme
    gnome3.gnome-desktop
    gtk3
    libcroco
    libxkbcommon
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

  # Hard-code Adwaita dark theme
  preFixup = ''
    gappsWrapperArgs+=(
      --set GTK_THEME "Adwaita:dark"
    )
  '';

  meta = with stdenv.lib; {
    description = "The final Librem5 keyboard";
    homepage = "https://source.puri.sm/Librem5/squeekboard";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
