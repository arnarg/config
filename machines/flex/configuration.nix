{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz;
in
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/arnar/Code/config/machines/flex/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    "${home-manager}/nixos"
    ../../modules
    ../../modules/os-specific/linux.nix
    ./hardware-configuration.nix
  ];

  local.development.enable = true;
  local.desktop.enable = true;
  local.profiles.laptop.enable = true;
  local.profiles.laptop.touch.enable = true;

  # Extra packages specific to this machine
  environment.systemPackages = with pkgs; [
    krita
  ];

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable iio-sensor-proxy for screen rotation
  hardware.sensor.iio.enable = true;

  networking = {
    hostId = "eb0a230e";
    hostName = "flex";
  };

  system.stateVersion = "19.09";
}
