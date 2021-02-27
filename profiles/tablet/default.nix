{ config, lib, mypkgs, ... }:
{
  config = {
    hardware.sensor.iio.enable = true;
    home-manager.users.arnar.wayland.windowManager.sway.config = {
      startup = [
        { command = "${mypkgs.sway-accel-rotate}/bin/sway-accel-rotate"; }
      ];
    };
  };
}
