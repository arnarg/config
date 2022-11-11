{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "rechts";

  # According to https://nixos.wiki/wiki/NixOS_on_ARM/UEFI
  # only grub2 works for now on ARM with UEFI
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  networking.interfaces.eth0.useDHCP = true;

  # tailscale
  services.tailscale.enable = true;

  # For setting up a tailscale exit node
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  networking.firewall.checkReversePath = "loose";

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

  # Persisting state
  environment.persistence."/nix/persist".directories = [
    "/var/lib/tailscale"
  ];

  system.stateVersion = "22.05";
}
