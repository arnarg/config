{ config, lib, ... }:
let
  cfg = config.local.services.transmission;
in with lib; {
  options.local.services.transmission.enable = mkEnableOption "transmission";

  config = mkIf cfg.enable {
    services.transmission.enable = true;
    services.transmission.settings = {
      download-dir = "/nix/persist/var/lib/transmission/Downloads";
      incomplete-dir = "/nix/persist/var/lib/transmission/.incomplete";
      incomplete-dir-enabled = true;
      rpc-bind-address = "0.0.0.0";
    };
    services.transmission.openFirewall = true;
  };
}
