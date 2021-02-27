{ config, lib, pkgs, ... }:
{
  config = {
    hardware.sensor.iio.enable = true;
    home-manager.users.arnar.wayland.windowManager.sway.config = {
      startup = [
        { command = "${pkgs.mypkgs.sway-accel-rotate}/bin/sway-accel-rotate"; }
      ];
    };
  };
}
