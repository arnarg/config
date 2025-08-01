{
  inputs,
  pkgs,
  ...
}: let
  tmProxyPort = 8081;
in {
  ##################
  ## Plugin Proxy ##
  ##################
  users.users.tm-proxy = {
    name = "tm-proxy";
    group = "tm-proxy";
    isSystemUser = true;
  };
  users.groups.tm-proxy.name = "tm-proxy";

  systemd.services.tm-proxy = let
    package = inputs.tm-proxy.result.packages.default.result.${pkgs.system};
  in {
    description = "Plugin proxy for typingmind";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    environment.CONFIG_PATH = pkgs.writeText "tm-proxy-config" ''
      address: ":${toString tmProxyPort}"

      plugins:
        prefixFile: /nix/persist/var/lib/tm-proxy/prefix
    '';

    serviceConfig = {
      User = "tm-proxy";
      Group = "tm-proxy";
      ExecStart = "${package}/bin/tm-proxy";
      Restart = "on-failure";
      RestartSec = "10s";
      StateDirectory = "tm-proxy";
      StateDirectoryMode = "0700";

      # Security options:
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";
      DeviceAllow = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;

      PrivateTmp = true;
      PrivateDevices = true;
      PrivateUsers = true;

      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = "read-only";
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "noaccess";
      ProtectSystem = "strict";

      RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };

  #############################
  ## Expose with cloudflared ##
  #############################
  services.cloudflared = {
    enable = true;

    certificateFile = "/nix/persist/var/lib/cloudflared/cert.pem";

    tunnels."08bc7196-3929-469f-86fd-7ff7b1ee6543" = {
      credentialsFile = "/nix/persist/var/lib/cloudflared/tm-proxy.json";
      default = "http_status:404";
      ingress = {
        "tm.cdbrdr.com" = "http://localhost:${toString tmProxyPort}";
      };
    };
  };
}
