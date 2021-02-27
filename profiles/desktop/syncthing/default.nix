{ config, lib, ... }:
let
  cfg = config.local.desktop.syncthing;
in with lib; {
  options.local.desktop.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    home-manager.users.arnar.services.syncthing.enable = true;
    networking.firewall.allowedTCPPorts = [ 22000 ];
    networking.firewall.allowedUDPPorts = [ 21027 ];
  };
}
