{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules
    ./hardware-configuration.nix
  ];

  config = {
    nix.nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
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

    local.server.enable = true;

    local.services.fancontrol.enable = true;
    # Because of the order in boot.kernelModules coretemp is always loaded before it87.
    # This makes hwmon0 coretemp and hwmon1 it8613e (acpitz is hwmon2).
    # This seems to be consistent between reboots.
    local.services.fancontrol.config = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon1=devices/platform/it87.2592
      DEVNAME=hwmon0=coretemp hwmon1=it8613
      FCTEMPS=hwmon1/pwm3=hwmon0/temp1_input
      FCFANS= hwmon1/pwm3=hwmon1/fan3_input
      MINTEMP=hwmon1/pwm3=20
      MAXTEMP=hwmon1/pwm3=60
      MINSTART=hwmon1/pwm3=52
      MINSTOP=hwmon1/pwm3=12
    '';

    networking.hostName = "terramaster";
    networking.useDHCP = false;
    networking.interfaces.enp1s0.useDHCP = true;

    system.stateVersion = "20.09";

    nix.gc = {
      automatic = true;
      dates = "Mon *-*-* 06:00:00";
      options = "--delete-older-than 35d";
    };
  };
}
