{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.kernelParams = ["mem_sleep_default=deep"];

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/47f531af-e03f-445e-a9e2-ff702936b852";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=16G" "mode=755"];
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

  fileSystems."/home" = {
    label = "nixos";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
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
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-uuid/eb7fedfc-4e05-410a-96af-ce1ea5e7da4c";
        label = "encswap";
      };
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
