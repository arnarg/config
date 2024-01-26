{
  lib,
  modulesPath,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["usb_storage" "uas"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./rk-spi.nix {})
  ];

  fileSystems."/" = {
    label = "nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/ca7761f8-d4be-4076-81e2-75bdeff59b1e";}
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
