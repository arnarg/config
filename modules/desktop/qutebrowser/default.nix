{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.qutebrowser;
in with lib; {
  options.local.desktop.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };

  config = mkIf cfg.enable {
    home-manager.users.arnar = {
      programs.qutebrowser.enable = true;

      programs.qutebrowser.searchEngines = {
        g = "https://duckduckgo.com/?q={}";
        np = "https://search.nixos.org/packages?channel=unstable&query={}";
        no = "https://search.nixos.org/options?query={}";
      };
    };
  };
}
