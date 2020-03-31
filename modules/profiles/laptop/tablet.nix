{ config, lib, pkgs, ... }:
let
  cfg = config.local.laptop.tablet;
  swayEnabled = config.local.desktop.sway.enable;
in with lib; {
  options.local.laptop.tablet = {
    enable = mkEnableOption "tablet";
  };

  config = mkIf (cfg.enable && swayEnabled) {

    local.desktop.sway.extraConfig = mkAfter ''
      exec ${pkgs.mypkgs.sway-accel-rotate}/bin/sway-accel-rotate
    '';

  };
}
