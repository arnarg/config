{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "hddled_tmj33-${version}-${kernel.version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "arnarg";
    repo = "hddled_tmj33";
    rev = version;
    sha256 = "0izz2xxg47rsj88pfqrx035n8hz78bqna41vljwc29r8aid9rnk9";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # We don't want to depmod yet, just build and package the module
  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc"
  ];

  meta = with stdenv.lib; {
    description = "A linux module for controlling the HDD LEDs on Terramaster NAS devices with Intel J33xx CPU";
    homepage = https://github.com/arnarg/hddled_tmj33;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
