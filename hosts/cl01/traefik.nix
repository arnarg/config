{
  lib,
  config,
  ...
}: let
  domain = "cdbrdr.com";
  mkServiceConfig = name: url: {
    http.routers."${name}" = {
      rule = "Host(`${name}.${domain}`)";
      service = name;
      middlewares = ["crowdsec"];
      tls.certResolver = "letsencrypt";
    };
    http.services."${name}" = {
      loadBalancer.servers = [{inherit url;}];
    };
  };
in {
  networking.firewall.allowedTCPPorts = [80 443];

  systemd.services.traefik.serviceConfig = let
    dataDir = config.services.traefik.dataDir;
  in {
    EnvironmentFile = ["${dataDir}/acme.env"];
    WorkingDirectory = dataDir;
  };

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
      storage = "${config.services.traefik.dataDir}/acme.json";
      dnsChallenge = {
        provider = "cloudflare";
        resolvers = [
          "1.1.1.1:53"
          "1.0.0.1:53"
        ];
      };
    };
    # Logging
    log.level = "INFO";
    accessLog.bufferingSize = 1;
    # CrowdSec bouncer plugin
    experimental.plugins.bouncer = {
      moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
      version = "v1.4.4";
    };
  };

  services.traefik.dynamicConfigOptions = lib.mkMerge [
    {
      http.middlewares.crowdsec.plugin.bouncer = {
        enabled = true;
        logLevel = "INFO";
        crowdsecMode = "live";
        crowdsecLapiHost = "127.0.0.1:8080";
        crowdsecLapiKeyFile = "/nix/persist/var/lib/traefik/crowdsec_key";
        crowdsecAppsecEnabled = true;
        crowdsecAppsecHost = "127.0.0.1:7422";
        crowdsecAppsecFailureBlock = true;
        crowdsecAppsecUnreachableBlock = true;
      };
    }
    (mkServiceConfig "tmps" "http://127.0.0.1:8081")
  ];
}
