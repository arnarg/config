{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.desktop.kde;
in
  with pkgs.stdenv;
  with lib; {
    options.local.desktop.kde = {
      enable = mkEnableOption "kde";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        whitesur-icon-theme
        whitesur-kde
        latte-dock
        libsForQt5.qtstyleplugin-kvantum
      ];

      services.xserver = {
        enable = true;
        displayManager.sddm.enable = true;
        desktopManager.plasma5.enable = true;
      };
    };
  }
