{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      redpanda
    ];
  };
}
