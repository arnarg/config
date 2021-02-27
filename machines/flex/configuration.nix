{ config, pkgs, lib, ... }:
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/arnar/Code/config/machines/flex/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    ../../modules
    ../../profiles/desktop
    ../../profiles/laptop
    ../../profiles/tablet
    ../../profiles/development
    ./hardware-configuration.nix
  ];

  local.immutable.enable = true;
  local.immutable.users = [ "arnar" ];

  local.laptop.waybind.inputDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  local.development.libvirt.enable = true;
  local.development.aerc.enable = true;
  local.desktop.syncthing.enable = true;

  # Extra packages specific to this machine
  environment.systemPackages = with pkgs; [
    krita
  ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  programs.steam.enable = true;

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostId = "eb0a230e";
    hostName = "flex";
  };

  system.stateVersion = "21.03";
}
