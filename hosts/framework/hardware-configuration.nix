{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/ec150a2a-03ec-450a-baab-e72dfa7f7a3b";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=16G"
      "mode=755"
    ];
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    label = "nixos";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    label = "nixos";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/var/log" = {
    label = "nixos";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "compress=zstd"
      "noatime"
    ];
    neededForBoot = true;
  };

  swapDevices = [
    {
      label = "swap";
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-uuid/59fc8f45-2c96-41bf-8fe7-a2191d3672b6";
        label = "encswap";
      };
    }
  ];
}
