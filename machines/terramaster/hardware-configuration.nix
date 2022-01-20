{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "uas" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
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
    options = [ "bind" ];
  };

  fileSystems."/tank" = {
    device = "/dev/disk/by-uuid/4f87db74-309f-4256-baaa-4596a22b04e5";
    fsType = "btrfs";
    options = [ "rw" "relatime" "space_cache" "subvolid=257" "subvol=/tank" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/tank" ];
    interval = "Mon *-*-* 03:00:00";
  };

  local.immutable.persistDevice = "/nix";
  local.immutable.persistPath = "/nix/persist";

  nix.maxJobs = 2;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
