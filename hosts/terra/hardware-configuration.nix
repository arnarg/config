{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  kernel = config.boot.kernelPackages.kernel;
  hddled = pkgs.stdenv.mkDerivation rec {
    name = "hddled_tmj33-${version}-${kernel.version}";
    version = "0.2";

    src = pkgs.fetchFromGitHub {
      owner = "arnarg";
      repo = "hddled_tmj33";
      rev = version;
      sha256 = "sha256-h2yvaFC0uemt9TZO1FR4Kfqm2bErol7KzjL6SOqtHik=";
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
  };
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "usb_storage" "uas" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = [];

  boot.extraModulePackages = with pkgs.linuxPackages; [
    # Terramaster F2-221 has an it8613e chip
    it87
    # Custom kernel module for controlling the HDD leds
    # on Terramaster F2-221
    hddled
  ];
  boot.kernelModules = [
    # For virtualization
    "kvm-intel"
    # For fancontrol
    "coretemp"
    # Terramaster F2-221 has an it8613e chip
    "it87"
    # Custom kernel module for controlling the HDD leds
    # on Terramaster F2-221
    "hddled_tmj33"
  ];

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
    label = "nixos";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    label = "nixos";
    fsType = "btrfs";
    options = ["subvol=log" "compress=zstd" "noatime"];
    neededForBoot = true;
  };

  swapDevices = [
    {
      label = "swap";
    }
  ];

  fileSystems."/tank" = {
    device = "/dev/disk/by-uuid/4f87db74-309f-4256-baaa-4596a22b04e5";
    fsType = "btrfs";
    options = ["rw" "relatime" "space_cache" "subvolid=257" "subvol=/tank"];
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/tank"];
    interval = "Mon *-*-* 00:00:00";
  };

  nix.settings.max-jobs = 2;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
