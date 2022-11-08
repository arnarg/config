{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # According to https://nixos.wiki/wiki/NixOS_on_ARM/UEFI
  # only grub2 works for now on ARM with UEFI
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  networking.interfaces.eth0.useDHCP = true;

  users.users.arnar = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  services.openssh.enable = true;

  # tailscale
  services.tailscale.enable = true;

  # For setting up a tailscale exit node
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  networking.firewall.checkReversePath = "loose";

  system.stateVersion = "22.05";
}
