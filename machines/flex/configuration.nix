{ config, pkgs, lib, ... }:
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/arnar/Code/config/machines/flex/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    ../../modules
    ./hardware-configuration.nix
  ];

  local.development.enable = true;
  local.desktop.enable = true;
  local.laptop.enable = true;
  local.laptop.tablet.enable = true;
  local.immutable.enable = true;
  local.immutable.users = [ "arnar" ];

  local.programs.waybind.inputDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  local.programs.aerc.enable = true;
  local.services.syncthing.enable = true;

  # Extra packages specific to this machine
  environment.systemPackages = with pkgs; [
    krita
  ];

  programs.steam.enable = true;

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable iio-sensor-proxy for screen rotation
  hardware.sensor.iio.enable = true;

  # Enable libvirt
  local.development.libvirt.enable = true;

  networking = {
    hostId = "eb0a230e";
    hostName = "flex";
  };

  system.stateVersion = "21.03";
}
