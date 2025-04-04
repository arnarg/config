{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";

  boot.initrd.availableKernelModules = ["usbhid"];
  boot.initrd.kernelModules = [];
  boot.extraModulePackages = [];
  boot.kernelModules = [
    # Odroid N2 has PCF5863 RTC
    "rtc-pcf8563"
  ];

  # Install the dtb for Odroid N2
  hardware.deviceTree.filter = "meson-g12b-odroid-n2.dtb";

  fileSystems."/" = {
    label = "nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
