{ config, pkgs, lib, ... }:
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/arnar/Code/config/machines/thinkpad/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    ../../modules
    /etc/nixos/configuration.nix
    ./hardware-configuration.nix
  ];

  local.development.enable = true;
  local.desktop.enable = true;
  local.laptop.enable = true;

  local.services.syncthing.enable = true;

  local.programs.waybind.inputDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # SSH agent settings
  programs.ssh.startAgent = true;
  local.development.yubikey.defaultAuthSock = false;
  local.development.yubikey.SSHHosts = ["github.com"];

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

  # Enable printing
  services.printing.enable = true;

  # Enable LXC
  virtualisation.lxc.enable = true;

  networking = {
    hostId = "7648dca7";
    hostName = "thinkpad";
  };

  system.stateVersion = "20.03";
}
