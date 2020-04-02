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
      serviceConfig.ExecStart = "${pkgs.mypkgs.plex-exporter}/bin/plex-exporter";
      serviceConfig.EnvironmentFile = "-/etc/plex_exporter/environment";
    };

    # default config
    environment.etc."plex-exporter/config.yaml" = {
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
      name = "plex-exporter";
      description = "plex-exporter user";
      group = "plex-exporter";
      createHome = false;
    };
    users.groups.plex-exporter = {
      name = "plex-exporter";
    };
  };
}
