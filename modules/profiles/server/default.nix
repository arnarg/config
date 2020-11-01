{ config, lib, ... }:
let
  cfg = config.local.server;
in with lib; {
  options.local.server = {
    enable = mkEnableOption "server";
  };

  config = mkIf cfg.enable {

    services.openssh.enable = true;

    time.timeZone = lib.mkForce "utc";

    services.prometheus.exporters.node.enable = true;
    services.prometheus.exporters.node.openFirewall = true;

    security.sudo.extraRules = [
      { users = [ "arnar" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
    ];

  };
}
