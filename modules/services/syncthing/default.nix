{ config, lib, ... }:
let
  cfg = config.local.services.syncthing;
in with lib; {
  options.local.services.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    home-manager.users.arnar.services.syncthing.enable = true;
    networking.firewall.allowedTCPPorts = [ 22000 ];
    networking.firewall.allowedUDPPorts = [ 21027 ];
  };
}
