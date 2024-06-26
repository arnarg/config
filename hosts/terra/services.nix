{
  config,
  lib,
  ...
}: let
  domain = "lab.codedbearder.com";
  mkServiceConfig = name: url: {
    http.routers."${name}" = {
      rule = "Host(`${domain}`) && PathPrefix(`/${name}`)";
      service = "${name}";
      tls.certResolver = "letsencrypt";
    };
    http.services."${name}" = {
      loadBalancer.servers = [{url = url;}];
    };
  };
in
  with lib; {
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
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist = "lab.codedbearder.com,localhost";
      rpc-host-whitelist-enabled = true;
    };
    services.transmission.group = "mediaowners";

    profiles.immutable.directories = [
      "/var/lib/transmission"
    ];

    users.groups.mediaowners.members = ["sonarr"];
    users.groups.mediaowners.gid = 3000;

    # Reverse Proxy
    systemd.services.traefik.serviceConfig = {
      EnvironmentFile = [(concatStrings ["-" config.services.traefik.dataDir "/acme.env"])];
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
        storage = concatStrings [config.services.traefik.dataDir "/acme.json"];
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
        # Strip prefix for duplicati
        http.middlewares.strip-duplicati.stripprefix = {
          prefixes = "/duplicati";
          forceSlash = false;
        };
        http.routers.duplicati.middlewares = ["strip-duplicati"];
      }
      (mkServiceConfig "sonarr" "http://127.0.0.1:8989/")
      (mkServiceConfig "radarr" "http://127.0.0.1:7878/")
      (mkServiceConfig "transmission" "http://127.0.0.1:9091/")
      (mkServiceConfig "duplicati" "http://127.0.0.1:8200/")
    ];

    # Firewall
    networking.firewall.allowedTCPPorts = [
      80 # Traefik
      443 # Traefik
    ];

    # Fix permissions between generations
    systemd.tmpfiles.rules = [
      "z /nix/persist/var/lib/traefik/acme.json 0600 traefik traefik"
    ];
  }
