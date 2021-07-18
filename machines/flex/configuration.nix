{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  local.immutable.enable = true;

  local.laptop.waybind.inputDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  local.development.libvirt.enable = true;
  local.desktop.gnome.enable = lib.mkForce true;

  # Extra packages specific to this machine
  environment.systemPackages = with pkgs; [
    krita
    blender
  ];

  time.timeZone = lib.mkOverride 40 "utc";

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking = {
    hostId = "eb0a230e";
    hostName = "flex";
  };

  system.stateVersion = "21.05";
}
