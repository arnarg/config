{ config, pkgs, lib, ... }:
let
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

    meta = with pkgs.stdenv.lib; {
      description = "A linux module for controlling the HDD LEDs on Terramaster NAS devices with Intel J33xx CPU";
      homepage = https://github.com/arnarg/hddled_tmj33;
      license = licenses.gpl2;
      platforms = [ "x86_64-linux" ];
    };
  };
in {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    # Whether to delete all files in /tmp during boot.
    boot.cleanTmpDir = true;
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    # I'm booting from an external USB drive so I
    # prefer not touching the EFI variables
    boot.loader.efi.canTouchEfiVariables = false;

    # Terramaster f2-221 has it8613e chip
    boot.extraModulePackages = with pkgs.linuxPackages; [ it87 hddled ];
    boot.kernelModules = ["coretemp" "it87" "hddled_tmj33"];

    # Plex Media Server
    services.plex.enable = true;
    services.plex.openFirewall = true;
    services.plex.managePlugins = false;
    local.immutable.links.tmpfiles = [
      "/var/lib/plex"
      "/etc/plex_exporter/environment"
    ];

    # Prometheus
    local.services.prometheus.enable = true;
    local.services.prometheus.exporters.plex.enable = true;
    local.services.grafana.enable = true;

    # Transmission
    local.services.transmission.enable = true;

    # Terramaster F2-221's fan is connected to a case fan header.
    # It doesn't spin up under load so I set up fancontrol to take care of this.
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

    # Networking stuff
    networking.hostName = "terramaster";
    networking.useDHCP = false;
    networking.interfaces.enp1s0.useDHCP = true;

    # My DNS has rebinding protection and Plex doesn't like that
    networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

    # NixOS stuff
    system.stateVersion = "20.09";
    nix.gc = {
      automatic = true;
      dates = "Mon *-*-* 06:00:00";
      options = "--delete-older-than 35d";
    };
  };
}
