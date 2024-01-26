{
  stdenv,
  kernel,
}:
stdenv.mkDerivation {
  pname = "spi_rockchip";
  version = kernel.version;

  src = kernel.src;

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${kernel.name}/drivers/spi
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "CONFIG_ROCKCHIP_SPI=m"
  ];

  buildFlags = ["modules"];
  installFlags = ["INSTALL_MOD_PATH=${placeholder "out"}"];
  installTargets = ["modules_install"];

  meta = {
    inherit (kernel.meta) license platforms;
  };
}
