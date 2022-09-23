{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  makeDesktopItem,
  electron,
}: let
  desktopItem = makeDesktopItem {
    name = "morgen";
    desktopName = "Morgen";
    comment = "Calendar";
    icon = "morgen";
    exec = "morgen";
    categories = ["Office"];
  };
in
  stdenv.mkDerivation rec {
    pname = "morgen";
    version = "2.5.16";

    src = fetchurl {
      url = "https://download.todesktop.com/210203cqcj00tw1/morgen-${version}.deb";
      sha256 = "0vn76s9gkjryn3whpf6ynm9bcj6im96c4nv6vmlksjhd0hxg5gjk";
    };

    nativeBuildInputs = [dpkg makeWrapper];

    unpackPhase = ''
      dpkg-deb -R $src .
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin

      makeWrapper ${electron}/bin/electron $out/bin/morgen \
        --add-flags $out/share/morgen/app.asar

      mkdir -p $out/share/morgen

      cp opt/Morgen/resources/app.asar $out/share/morgen/app.asar

      cp -r opt/Morgen/resources/app.asar.unpacked $out/share/morgen/app.asar.unpacked

      install -m 444 -D "${desktopItem}/share/applications/"* \
        -t $out/share/applications/

      for size in 16 32 48 64 128 256 512 1024; do
        install -m 444 -D usr/share/icons/hicolor/"$size"x"$size"/apps/morgen.png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/morgen.png
      done

      install -m 444 -D usr/share/mime/packages/morgen.xml $out/share/mime/packages/morgen.xml

      runHook postInstall
    '';
  }
