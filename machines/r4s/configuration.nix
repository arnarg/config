{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./interfaces.nix
    ./router
  ];

  networking.hostName = "r4s";

  # According to https://nixos.wiki/wiki/NixOS_on_ARM/UEFI
  # only grub2 works for now on ARM with UEFI
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    conntrack-tools
    dig
    ethtool
    htop
    tcpdump
    vim
  ];

  # tailscale
  services.tailscale.enable = true;
  # For setting up a tailscale exit node
  networking.firewall.checkReversePath = "loose";
  # Persisting state
  environment.persistence."/nix/persist".directories = [
    "/var/lib/tailscale"
  ];

  # So I can use nixos-rebuild with --use-remote-sudo
  # TODO: Figure out how to allow less commands
  security.sudo.extraRules = [
    {
      users = ["arnar"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  system.stateVersion = "22.05";
}
