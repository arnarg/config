{
  config,
  lib,
  pkgs,
  ...
}: let
  traefikDir = config.services.traefik.dataDir;
  tsInterface = config.services.tailscale.interfaceName;

  # my internal domain
  domain = "cdbrdr.com";

  # dynamic config helper
  mkServiceConfig = {
    name,
    url,
  }: {
    http.routers."${name}" = {
      rule = "Host(`${name}.${domain}`)";
      service = "${name}";
      tls.certResolver = "letsencrypt";
    };
    http.services."${name}" = {
      loadBalancer.servers = [{inherit url;}];
    };
  };
in
  with lib; {
    options.local.proxy = {
      services = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = "Name of the service";
            };
            url = mkOption {
              type = types.str;
              description = "URL to proxy to";
            };
          };
        });
        description = "List of services to proxy";
        default = [];
      };
    };

    config = {
      ###########################
      ## Traefik reverse proxy ##
      ###########################
      # Inject environment variables for acme DNS
      # This file should be owned by and only readable
      # by root!
      systemd.services.traefik.serviceConfig = {
        EnvironmentFile = concatStrings ["-" traefikDir "/acme.env"];
      };

      # Traefik settings
      services.traefik.enable = true;
      services.traefik.dataDir = "/nix/persist/var/lib/traefik";
      services.traefik.staticConfigOptions = {
        # Entrypoints
        entryPoints.http.address = ":80";
        entryPoints.http.http.redirections = {
          entryPoint.to = "https";
          entryPoint.scheme = "https";
          entryPoint.permanent = true;
        };
        entryPoints.https.address = ":443";
        # Let's encrypt
        certificatesResolvers.letsencrypt.acme = {
          email = "acme@codedbearder.com";
          storage = concatStrings [traefikDir "/acme.json"];
          dnsChallenge.provider = "cloudflare";
        };
        # Logging
        log.level = "INFO";
        accessLog.bufferingSize = 1;
      };

      # create the dynamixConfig
      services.traefik.dynamicConfigOptions = mkMerge (forEach config.local.proxy.services mkServiceConfig);

      ##############
      ## Firewall ##
      ##############
      # Only expose over tailscale interface
      networking.firewall.interfaces."${tsInterface}".allowedTCPPorts = [
        80
        443
      ];
    };
  }
