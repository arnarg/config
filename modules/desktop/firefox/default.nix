{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.firefox;
in with lib; {
  options.local.desktop.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {

    home-manager.users.arnar = {
      programs.firefox.enable = true;
      programs.firefox.package = pkgs.firefox-wayland;

      programs.firefox.profiles.default.id = 0;
      programs.firefox.profiles.default.isDefault = true;
      programs.firefox.profiles.default.settings = {
        # It keeps asking me on startup if I want firefox as default
        "browser.shell.checkDefaultBrowser" = false;
        # Set up display scaling
        "layout.css.devPixelsPerPx" = (builtins.toString config.local.displayScalingFactor);
      };
    };

  };
}
