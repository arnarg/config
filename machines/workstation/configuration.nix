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
    ../../modules/nixpkgs.nix
    ../../modules/users.nix
    ../../modules/home.nix
    ../../modules/desktop.nix
    ../../modules/kr.nix
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostId = "fdedf053";
    hostName = "workstation";
    interfaces.enp25s0.useDHCP = true;
  };

  system.stateVersion = "19.09";
}
