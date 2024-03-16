{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["usb_storage" "uas"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  # Root on tmpfs
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=2G" "mode=755"];
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    label = "nix";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = ["bind"];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
