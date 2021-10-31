{ lib,
stdenv,
fetchFromGitHub,
glib,
inkscape,
optipng,
sassc,
which,
gtk_engines,
gtk-engine-murrine,
util-linux,

icon ? "simple",
opacity ? "default",
monterey ? true }:

stdenv.mkDerivation rec {
  pname = "whitesur-gtk-theme";
  version = "2021-10-29";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-gtk-theme";
    rev = "00b04162bc3e3ef6369a78a8b5859cfc0878c55a";
    sha256 = "h/NIGQkAE53O70L7EIG71zAREfMf4jII0Kl24nUcA0I=";
  };

  patches = [./install.patch];

  nativeBuildInputs = [glib inkscape optipng sassc which util-linux];

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs .

    for f in src/assets/cinnamon/thumbnails/render-thumbnails.sh \
             src/assets/gtk-2.0/render-assets.sh \
             src/assets/gtk/common-assets/render-assets.sh \
             src/assets/gtk/common-assets/render-sidebar-assets.sh \
             src/assets/gtk/thumbnails/render-thumbnails.sh \
             src/assets/gtk/windows-assets/render-alt-assets.sh \
             src/assets/gtk/windows-assets/render-alt-small-assets.sh \
             src/assets/gtk/windows-assets/render-assets.sh \
             src/assets/gtk/windows-assets/render-small-assets.sh \
             src/assets/render-all-assets.sh \
             src/assets/xfwm4/render-assets.sh
    do
      substituteInPlace $f \
        --replace /usr/bin/inkscape ${inkscape}/bin/inkscape \
        --replace /usr/bin/optipng ${optipng}/bin/optipng
    done

    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  params = [
    "-d $out/share/themes"
    "--silent-mode"
    "--icon ${icon}"
    "--panel-opacity ${opacity}"
  ] ++ lib.optional monterey "--monterey";

  installPhase = ''
    mkdir -p $out/share/themes
    name= ./install.sh ${lib.concatStringsSep " " params}
  '';
}
