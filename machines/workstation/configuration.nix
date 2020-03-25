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
    ../../modules/docker.nix
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    blender
    krita
  ];

  boot.cleanTmpDir = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  local.home.userName = "arnar";

  # For some gaming
  hardware.opengl.driSupport32Bit = true;
  home-manager.users.arnar.home.packages = [ pkgs.steam ];

  # Run krd
  home-manager.users.arnar.systemd.user.services.krd = {
    Unit = {
      Description = "Krypton daemon";
    };
    Service = {
      ExecStart = "${pkgs.mypkgs.kr}/bin/krd";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  networking = {
    hostId = "fdedf053";
    hostName = "workstation";
    interfaces.enp25s0.useDHCP = true;
  };

  system.stateVersion = "19.09";
}
