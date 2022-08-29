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

  boot.initrd.availableKernelModules = ["usbhid"];
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

  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = ["bind"];
  };

  local.immutable.persistDevice = "/nix";
  local.immutable.persistPath = "/nix/persist";

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
