{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz;
in
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/arnar/Code/config/machines/thinkpad/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    "${home-manager}/nixos"
    ../../modules
    /etc/nixos/configuration.nix
    ./hardware-configuration.nix
  ];

  local.development.enable = true;
  local.desktop.enable = true;
  local.laptop.enable = true;

  local.programs.waybind.inputDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable libvirt
  local.development.libvirt.enable = true;

  # Long zsh history
  home-manager.users.arnar.programs.zsh.history = {
    size = lib.mkForce 10000000;
    save = lib.mkForce 10000000;
  };

  # Enable vpn waybar module
  local.desktop.sway.waybar.config.modules-right = lib.mkBefore [ "custom/vpn" ];

  # Fix positioning of external monitors
  home-manager.users.arnar.wayland.windowManager.sway.config.output = {
    DP-3 = { pos = "0 0"; };
    DP-4 = { pos = "2560 0"; };
  };

  networking = {
    hostId = "7648dca7";
    hostName = "thinkpad";
  };

  system.stateVersion = "20.03";
}
