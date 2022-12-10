{
  config,
  lib,
  pkgs,
  ...
}: let
  traefikDir = config.services.traefik.dataDir;

  # Internal domain
  domain = "cdbrdr.com";
in
  with lib; {
    options.local.proxy = {
      services = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            name = mkOption {
              type = types.nullOr types.str;
              description = "Name of the service";
              default = null;
            };
            url = mkOption {
              type = types.str;
              description = "URL to proxy to";
            };
          };
        });
        description = "List of services to proxy";
        default = {};
      };
    };

    config = {
      # Inject environment variables for acme DNS
      # This file should be owned by and only readable
      # by root!
      systemd.services.traefik.serviceConfig = {
        EnvironmentFile = lib.concatStrings ["-" traefikDir "/acme.env"];
      };

      # Traefik settings
      # Not yet ready to switch over to traefik per host
      services.traefik.enable = false;
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
        entryPoints.https.http.tls.certResolver = "letsencrypt";

        # Let's encrypt
        certificatesResolvers.letsencrypt.acme = {
          email = "acme@codedbearder.com";
          storage = lib.concatStrings [traefikDir "/acme.json"];
          dnsChallenge.provider = "cloudflare";
        };

        # Logging
        log.level = "INFO";
        accessLog.bufferingSize = 1;
      };

      # create the dynamicConfig
      services.traefik.dynamicConfigOptions =
        mapAttrs (n: v: let
          name =
            if isNull v.name
            then n
            else v.name;
        in {
          http.routers."${name}" = {
            rule = "Host(`${name}.${domain}`)";
            service = name;
          };
          http.services."${name}" = {
            loadBalancer.servers = [{inherit (v) url;}];
          };
        })
        config.local.proxy.services;

      # Avahi service discovery
      services.avahi.publish.userServices = true;
      services.avahi.extraServiceFiles.proxy = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">Service proxy on %h</name>
          <service>
            <type>_https._tcp</type>
            <port>443</port>
            <txt-record>type=svc-proxy</txt-record>
            <txt-record>services=${builtins.concatStringsSep "," (mapAttrsToList (n: v:
          if isNull v.name
          then n
          else v.name)
        config.local.proxy.services)}</txt-record>
          </service>
        </service-group>
      '';
      # Make sure changes to the proxy avahi user service
      # triggers a restart of avahi-daemon
      systemd.services."avahi-daemon".restartTriggers = [config.environment.etc."avahi/services/proxy.service".source];
    };
  }
