{
  config,
  lib,
  pkgs,
  ...
}: let
  traefikDir = config.services.traefik.dataDir;

  # Internal domain
  domain = "cdbrdr.com";
in {
  # Inject environment variables for acme DNS
  # This file should be owned by and only readable
  # by root!
  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = lib.concatStrings ["-" traefikDir "/acme.env"];
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
    entryPoints.https.http.tls.certResolver = "letsencrypt";

    # Let's encrypt
    certificatesResolvers.letsencrypt.acme = {
      email = "acme@codedbearder.com";
      storage = lib.concatStrings [traefikDir "/acme.json"];
      dnsChallenge.provider = "cloudflare";
    };

    # Providers
    providers.consulCatalog = {
      defaultRule = "Host(`{{ .Name }}.${domain}`)";
      connectAware = true;
      connectByDefault = true;
    };

    # Logging
    log.level = "INFO";
    accessLog.bufferingSize = 1;
  };

  # Register a service in consul
  environment.etc."consul.d/traefik.json".text = builtins.toJSON {
    service = {
      name = "traefik";
      port = 443;
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [80 443];
}
