{ config, lib, pkgs, ... }:
let
  cfg = config.local.services.grafana;
in with lib; {
  options.local.services.grafana = {
    enable = mkEnableOption "grafana";
    adminUser = mkOption {
      type = types.str;
      default = "arnar";
      description = "Name of the admin user.";
    };
  };

  config = mkIf cfg.enable {
    services.grafana.enable = true;
    services.grafana.addr = "0.0.0.0";
    services.grafana.security.adminUser = cfg.adminUser;

    services.grafana.provision.datasources = [
      (mkIf config.services.prometheus.enable {
        name = "prometheus";
        isDefault = true;
        type = "prometheus";
        url = "http://localhost:9090";
      })
    ];

    networking.firewall.allowedTCPPorts = [ 3000 ];
  };
}
