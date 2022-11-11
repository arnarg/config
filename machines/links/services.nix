{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./services/microbin.nix
  ];

  ############
  ## SHIORI ##
  ############
  services.shiori.enable = true;

  ##########
  ## YARR ##
  ##########
  systemd.services.yarr = let
    yarrPkg = inputs.unstable.legacyPackages.${config.nixpkgs.system}.yarr;
  in {
    description = "Yet another rss reader";
    wantedBy = ["multi-user.target"];

    environment = {
      XDG_CONFIG_HOME = "/var/lib/yarr";
      YARR_DB = "/var/lib/yarr/yarr.db";
      YARR_ADDR = "127.0.0.1:7070";
    };

    serviceConfig = {
      ExecStart = "${yarrPkg}/bin/yarr";

      DynamicUser = true;
      StateDirectory = "yarr";
      # As the RootDirectory
      RuntimeDirectory = "yarr";

      # Security options
      BindReadOnlyPaths = [
        "/nix/store"
        # For SSL certificates, and the resolv.conf
        "/etc"
      ];
      CapabilityBoundingSet = "";
      DeviceAllow = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      PrivateDevices = true;
      PrivateUsers = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RootDirectory = "/run/yarr";
      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = [
        "@system-service"
        "~@cpu-emulation"
        "~@debug"
        "~@keyring"
        "~@memlock"
        "~@obsolete"
        "~@privileged"
        "~@setuid"
      ];
    };
  };

  ##################################
  ## Persisting state directories ##
  ##################################
  environment.persistence."/nix/persist".directories = [
    "/var/lib/shiori"
    "/var/lib/yarr"
  ];

  ###########
  ## Proxy ##
  ###########
  local.proxy.services = [
    {
      name = "shiori";
      url = "http://localhost:8080";
    }
    {
      name = "reader";
      url = "http://localhost:7070";
    }
  ];
}
