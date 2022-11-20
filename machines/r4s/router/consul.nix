{
  config,
  lib,
  pkgs,
  ...
}: {
  services.consul = {
    enable = true;
    webUi = true;
    interface.bind = "lan0";
    interface.advertise = "lan0";
    extraConfig = {
      node_name = config.networking.hostName;
      server = true;
      data_dir = "/nix/persist/var/lib/consul";
      bootstrap = true;

      ports.grpc = 8502;
      connect.enabled = true;

      config_entries.bootstrap = [
        {
          kind = "proxy-defaults";
          name = "global";
          config = {
            protocol = "http";
            envoy_prometheus_bind_addr = "0.0.0.0:9102";
          };
        }
      ];
    };
  };

  networking.firewall.interfaces.lan0.allowedTCPPorts = [8300 8301 8502];
  networking.firewall.interfaces.lan0.allowedUDPPorts = [8301];

  # For envoy sidecar traffic
  networking.firewall.interfaces.lan0.allowedTCPPortRanges = [
    {
      from = 21000;
      to = 21255;
    }
  ];
}