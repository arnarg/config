{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["usbhid" "usb_storage"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=2G" "mode=755"];
  };

  fileSystems."/nix" = {
    label = "nix";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
