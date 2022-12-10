{
  config,
  lib,
  pkgs,
  ...
}: let
  localServices = config.local.consul.services;
in {
  imports = [
    ./proxy.nix
  ];

  options.local.consul.services = with lib;
    mkOption {
      type = types.attrsOf types.attrs;
      default = {};
    };

  config = {
    ############
    ## Consul ##
    ############
    services.consul = {
      enable = true;
      interface.bind = "eth0";
      interface.advertise = "eth0";
      extraConfig = {
        node_name = config.networking.hostName;
        data_dir = "/nix/persist/var/lib/consul";
        leave_on_terminate = false;

        retry_join = ["provider=mdns service=_consul-server._tcp domain=local"];

        ports.grpc = 8502;
        connect.enabled = true;
      };
    };

    networking.firewall.interfaces.eth0.allowedTCPPorts = [8300 8301 8502];
    networking.firewall.interfaces.eth0.allowedUDPPorts = [8301];

    # For envoy sidecar traffic
    networking.firewall.interfaces.eth0.allowedTCPPortRanges = [
      {
        from = 21000;
        to = 21255;
      }
    ];

    # Write service files
    environment.etc = with lib;
      mapAttrs'
      (n: v: nameValuePair ("consul.d/" + n + ".json") {text = builtins.toJSON {service = v;};})
      localServices;

    # Start sidecar proxies
    systemd.services = with lib;
      mkMerge (
        # Iterate over all service configs and increment the admin-bind port
        # Otherwise they will all try to bind to 16000
        imap0 (
          i: v: {
            "${v.name}" =
              v.service
              // {
                serviceConfig.ExecStart = v.service.serviceConfig.ExecStart + " -admin-bind 127.0.0.1:${toString (16000 + i)}";
              };
          }
        )
        (
          # Map to a systemd service list
          mapAttrsToList (
            n: v: {
              name = "${n}-envoy-sidecar";
              service = {
                description = "Consul connect sidecar for ${n}";
                wantedBy = ["multi-user.target" "consul.service"];
                after = ["consul.service"];
                requires = ["consul.service"];
                path = [pkgs.envoy];

                serviceConfig = {
                  ExecStart = "${pkgs.consul}/bin/consul connect envoy -sidecar-for ${n}";
                  ExecStop = "${pkgs.coreutils}/bin/sleep 5";
                  Restart = "always";
                };
              };
            }
          )
          # Filter out all services that don't have connect.sidecar_service set
          (filterAttrs (k: v: hasAttrByPath ["connect" "sidecar_service"] v) localServices)
        )
      );
  };
}
