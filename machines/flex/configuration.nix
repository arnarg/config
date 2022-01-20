{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  local.development.libvirt.enable = true;
  local.desktop.gnome.enable = lib.mkForce true;

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.avahi.enable = true;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking = {
    hostId = "eb0a230e";
    hostName = "flex";
  };

  system.stateVersion = "21.11";
}
