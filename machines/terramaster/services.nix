{ config, pkgs, lib, ... }:
let
  domain = "lab.codedbearder.com";
  mkServiceConfig = name: url: {
    http.routers."${name}" = {
      rule = "Host(`${domain}`) && PathPrefix(`/${name}`)";
      service = "${name}";
      tls.certResolver = "letsencrypt";
    };
    http.services."${name}" = {
      loadBalancer.servers = [ { url = url; } ];
    };
  };
in with lib; {
  # Plex Media Server
  services.plex.enable = true;
  services.plex.openFirewall = true;

  # Sonarr
  services.sonarr.enable = true;
  services.sonarr.dataDir = "/nix/persist/var/lib/sonarr/.config/NzbDrone";
  services.sonarr.group = "mediaowners";

  # Radarr
  services.radarr.enable = true;
  services.radarr.dataDir = "/nix/persist/var/lib/radarr/.config/NzbDrone";
  services.radarr.group = "mediaowners";

  # Transmission
  services.transmission.enable = true;
  services.transmission.settings = {
    download-dir = "/nix/persist/var/lib/transmission/Downloads";
    incomplete-dir = "/nix/persist/var/lib/transmission/.incomplete";
    incomplete-dir-enabled = true;
    rpc-bind-address = "0.0.0.0";
    rpc-host-whitelist = "lab.codedbearder.com,localhost";
    rpc-host-whitelist-enabled = true;
  };
  services.transmission.group = "mediaowners";

  users.groups.mediaowners.members = [ "sonarr" ];
  users.groups.mediaowners.gid = 3000;

  # Reverse Proxy
  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = concatStrings [ "-" config.services.traefik.dataDir "/acme.env" ];
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
      storage = concatStrings [ config.services.traefik.dataDir "/acme.json" ];
      dnsChallenge.provider = "cloudflare";
    };
    # Logging
    log.level = "INFO";
    accessLog.bufferingSize = 1;
  };
  services.traefik.dynamicConfigOptions = mkMerge [
    {
      # Transmission doesn't redirect to /transmission/web
      # after I proxy with https. Here I force that to happen.
      http.middlewares.redirect-transmission.redirectregex = {
        regex = "^https://${domain}/transmission/?$";
        replacement = "https://${domain}/transmission/web/";
        permanent = true;
      };
      http.routers.transmission.middlewares = ["redirect-transmission"];
    }
    (mkServiceConfig "sonarr" "http://127.0.0.1:8989/")
    (mkServiceConfig "radarr" "http://127.0.0.1:7878/")
    (mkServiceConfig "transmission" "http://127.0.0.1:9091/")
  ];

  # NATS
  services.nats.enable = true;
  services.nats.jetstream = true;
  services.nats.dataDir = "/nix/persist/var/lib/nats";

  # InfluxDB
  services.influxdb2.enable = true;

  # Firewall
  networking.firewall.allowedTCPPorts = [
    80   # Traefik
    443  # Traefik
    4222 # NATS
    8086 # InfluxDB
  ];

  # Immutable
  local.immutable.links.tmpfiles = [
    "/var/lib/plex"                     # Plex
    "/etc/plex_exporter/environment"    # Plex exporter
    "/var/lib/influxdb2/engine"         # InfluxDB2
    "/var/lib/influxdb2/influxd.bolt"   # InfluxDB2
    "/var/lib/influxdb2/influxd.sqlite" # InfluxDB2
  ];
}
