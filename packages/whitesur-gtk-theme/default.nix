{ lib,
stdenv,
fetchFromGitHub,
fetchzip,
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
  version = "2021-12-28";

  srcs = [
    (fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-gtk-theme";
      rev = version;
      sha256 = "zIF4jKmPL+sE/0N6NKz4MhYJyxgR0uicQ9cxNllUAUU=";
    })
    (fetchzip {
      name = "wallpapers";
      url = "https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/c9dcf70d66a23bb639c0a2d7c36ddd88ab0e0883.zip";
      sha256 = "kJrCjlkaDW3eogHlDpOA1xOw5FkAgYU/gT4Pd+djIR8=";
    })
  ];

  sourceRoot = "source";

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
    mkdir -p $out/share/wallpapers
    cp -r ../wallpapers/4k/${if monterey then "Monterey" else "WhiteSur"}*.png $out/share/wallpapers
  '';
}
