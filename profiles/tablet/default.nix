{ config, lib, pkgs, ... }:
{
  config = {
    hardware.sensor.iio.enable = true;
  };
}
