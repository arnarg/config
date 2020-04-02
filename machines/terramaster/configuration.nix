{ config, pkgs, lib, ... }:

{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/arnar/Code/config/machines/terramaster/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
"
  ];

  imports = [
    ../../modules
    ../../modules/os-specific/linux.nix
    ./hardware-configuration.nix
    ./fancontrol.nix
    ./nfs.nix
    ./plex.nix
  ];

  # Whether to delete all files in /tmp during boot.
  boot.cleanTmpDir = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  # I'm booting from an external USB drive so I
  # prefer not touching the EFI variables
  boot.loader.efi.canTouchEfiVariables = false;

  # Terramaster f2-221 has it8613e chip
  boot.extraModulePackages = with pkgs.linuxPackages; [ it87 pkgs.mypkgs.hddled ];
  boot.kernelModules = ["coretemp" "it87" "hddled_tmj33"];

  # Enable SSH
  services.openssh.enable = true;

  time.timeZone = lib.mkOverride "utc";

  networking = {
    hostName = "terramaster";
    # Global useDHCP flag is deprecated
    useDHCP = false;
    interfaces = {
      enp1s0 = {
        useDHCP = true;
      };
      enp2s0 = {
        useDHCP = true;
      };
    };
    firewall.enable = true;
  };

  # Metrics
  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.openFirewall = true;
  services.local.prometheus.exporters.plex.enable = true;
  services.local.prometheus.exporters.plex.openFirewall = true;

  # NixOS settings
  system = {
    stateVersion = "19.09";
    autoUpgrade = {
      enable = true;
      dates = "Sun *-*-* 04:00:00";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "Mon *-*-* 06:00:00";
    options = "--delete-older-than 35d";
  };
}
