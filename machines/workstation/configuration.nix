{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz;
in
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/arnar/Code/config/machines/workstation/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    "${home-manager}/nixos"
    ../../modules
    ../../modules/os-specific/linux.nix
    ./hardware-configuration.nix
  ];

  local.displayScalingFactor = 1.2;
  local.development.enable = true;
  local.desktop.enable = true;

  # Extra packages specific to this machine
  environment.systemPackages = with pkgs; [
    blender
    krita
  ];

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # For some gaming
  hardware.opengl.driSupport32Bit = true;
  home-manager.users.arnar.home.packages = [ pkgs.steam ];

  networking = {
    hostId = "fdedf053";
    hostName = "workstation";
    interfaces.enp25s0.useDHCP = true;
  };

  system.stateVersion = "19.09";
}
