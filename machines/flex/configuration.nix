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
    ../../modules/lib
    ../../modules/profiles/laptop.nix
    ../../modules/nixpkgs.nix
    ../../modules/users.nix
    ../../modules/home.nix
    ../../modules/desktop.nix
    ../../modules/sway
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    krita
  ];

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I want the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  local.home.userName = "arnar";

  # Enable iio-sensor-proxy for screen rotation
  hardware.sensor.iio.enable = true;

  # Enables d-bus activation of squeekboard
  home-manager.users.arnar.xdg.dataFile."dbus-1/services/sm.puri.OSK0.service" = {
    text = ''
      [D-BUS Service]
      Name=sm.puri.OSK0
      Exec=${pkgs.mypkgs.squeekboard}/bin/squeekboard
      User=arnar
    '';
  };

  # Add button to toggle squeekboard
  local.desktop.sway.waybar.config = {
    "custom/squeekboard" = {
      format = "";
      on-click = "${pkgs.mypkgs.desktop-scripts}/waybar/squeekboard.sh";
    };
    modules-right = lib.mkAfter [ "custom/squeekboard" ];
  };

  local.desktop.sway.extraConfig = lib.mkAfter ''
    # Workaround for squeekboard
    seat seat0 keyboard_grouping none
  '';

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
    hostId = "eb0a230e";
    hostName = "flex";
  };

  system.stateVersion = "19.09";
}
