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

  # Enables d-bus activation of virtboard
  home-manager.users.arnar.xdg.dataFile."dbus-1/services/sm.puri.OSK0.service" = {
    text = ''
      [D-BUS Service]
      Name=sm.puri.OSK0
      Exec=${pkgs.mypkgs.squeekboard}/bin/squeekboard
      User=arnar
    '';
  };

  # Script to toggle virtboard
  home-manager.users.arnar.xdg.configFile."waybar/scripts/virtboard.sh" = {
    text = ''
      #!/usr/bin/env bash
      if [[ "$1" == "click" ]]; then
        for i in 1 2 3 4; do
          currentState=`busctl --user get-property sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible`
          if [[ $? == 0 ]]; then break; fi
          sleep 0.1
        done
        case "$currentState" in
        "b true")
          busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
          ;;
        "b false")
          busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
          ;;
        esac
      fi
    '';
  };
  local.desktop.sway.waybar.extraConfig = {
    "custom/virtboard" = {
      format = "";
      on-click = "${pkgs.bash}/bin/bash /home/arnar/.config/waybar/scripts/virtboard.sh click";
    };
    modules-right = [ "custom/lang" "network" "pulseaudio" "battery" "clock" "custom/virtboard" ];
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
