{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.gnome;
in with pkgs.stdenv; with lib; {
  options.local.desktop.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
    };

    environment.enableDebugInfo = true;

  };
}
