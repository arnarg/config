{ config, lib, pkgs, ... }:
let
  cfg = config.local.laptop.tablet;
  swayEnabled = config.local.desktop.sway.enable;
in with lib; {
  options.local.laptop.tablet = {
    enable = mkEnableOption "tablet";
  };

  config = mkIf (cfg.enable && swayEnabled) {

    home-manager.users.arnar.wayland.windowManager.sway.config = {
      startup = [
        { command = "${pkgs.mypkgs.sway-accel-rotate}/bin/sway-accel-rotate"; }
      ];
    };

  };
}
