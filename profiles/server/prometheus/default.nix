{ config, lib, pkgs, ... }:
let
  cfg = config.local.services.prometheus;
  nodeExporterEnabled = config.services.prometheus.exporters.node.enable;
in with lib; {
  imports = [
    ./plex-exporter.nix
  ];

  options.local.services.prometheus = {
    enable = mkEnableOption "prometheus";
  };

  config = mkIf cfg.enable {
    services.prometheus.enable = true;

    services.prometheus.scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          { targets = [ "localhost:9090" ]; }
        ];
      }
      (mkIf nodeExporterEnabled {
        job_name = "node_exporter";
        static_configs = [
          { targets = [ "localhost:9100" ]; }
        ];
      })
    ];
  };
}
