{ lib,
stdenv,
fetchFromGitHub,
gtk3,
hicolor-icon-theme,

bold ? true }:

stdenv.mkDerivation rec {
  pname = "whitesur-icon-theme";
  version = "2021-10-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-icon-theme";
    rev = version;
    sha256 = "BP5hGi3G9zNUSfeCbwYUvd3jMcWhstXiDeZCJ6Hgey8=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  params = [
    "-d $out/share/icons"
    "--name WhiteSur"
  ] ++ lib.optional bold "--bold";

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh
    mkdir -p $out/share/icons
    ./install.sh ${lib.concatStringsSep " " params}

    runHook postInstall
  '';
}
