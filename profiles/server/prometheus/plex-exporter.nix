{ config, lib, pkgs, ... }:
let
  cfg = config.local.services.prometheus.exporters.plex;
in with pkgs.stdenv; with lib; {
  options.local.services.prometheus.exporters.plex = {
    enable = mkEnableOption "plex_exporter";
    openFirewall = mkEnableOption "firewall";
  };

  config = mkIf cfg.enable {
    # systemd service
    systemd.services.plex-exporter = {
      description = "Prometheus exporter for a few Plex Media Server metrics";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.User = "plex-exporter";
      serviceConfig.Group = "plex-exporter";
      serviceConfig.ExecStart = "${pkgs.plex-exporter}/bin/plex_exporter";
      serviceConfig.EnvironmentFile = "-/etc/plex_exporter/environment";
    };

    # default config
    environment.etc."plex_exporter/config.yaml" = {
      text = ''
        autoDiscover: true
      '';
    };

    # open firewall
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9594 ];
    };

    # user and group
    users.users.plex-exporter = {
      isSystemUser = true;
      name = "plex-exporter";
      description = "plex-exporter user";
      group = "plex-exporter";
      createHome = false;
    };
    users.groups.plex-exporter = {
      name = "plex-exporter";
    };

    # in case prometheus is enabled on the host
    services.prometheus.scrapeConfigs = [
      {
        job_name = "plex";
        static_configs = [
          { targets = [ "localhost:9594" ]; }
        ];
      }
    ];
  };
}
