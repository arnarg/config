{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.ente-backup;
in {
  options.services.ente-backup = with lib; {
    enable = mkEnableOption "ente-backup";
    user = mkOption {
      type = types.str;
      default = "ente-backup";
      description = "User to run the ente backup";
    };
    group = mkOption {
      type = types.str;
      default = "ente-backup";
      description = "Group to run the ente backup";
    };
  };

  config = lib.mkIf cfg.enable {
    profiles.immutable.directories = [
      "/var/lib/ente-backup"
      "/var/backups/ente"
    ];

    users = {
      users.${cfg.user} = {
        name = cfg.user;
        group = cfg.group;
        isSystemUser = true;
      };
      groups.${cfg.group}.name = cfg.group;
    };

    # Backup from Ente Photos to SSD
    systemd.services.ente-backup = {
      description = "Backup of Ente Photos";
      after = ["network.target"];
      environment = {
        ENTE_CLI_SECRETS_PATH = "%S/ente-backup/secrets";
        ENTE_CLI_CONFIG_PATH = "%S/ente-backup/config";
        ENTE_CLI_TMP_PATH = "%S/ente-backup/tmp";
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.ente-cli}/bin/ente export";
        Restart = "on-failure";
        RestartSec = "10s";
        StateDirectory = "ente-backup";
        StateDirectoryMode = "0700";

        # Give read-write access to the backups directory
        ReadWritePaths = ["/var/backups/ente"];

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

    systemd.timers.ente-backup = {
      description = "Periodically run Ente Photos backup";
      partOf = ["ente-backup.service"];
      wantedBy = ["timers.target"];
      after = ["network.target"];
      timerConfig = {
        # Daily at 10:00 UTC
        OnCalendar = "*-*-* 10:00:00";
        Persistent = true;
      };
    };

    # rsync from SSD to HDD mirror
    systemd.services.ente-tank-backup = {
      description = "Backup Ente Photos to tank storage";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.rsync}/bin/rsync --verbose --archive --delete /var/backups/ente/ /tank/BACKUP/ente";
        Restart = "on-failure";
        RestartSec = "10s";

        # Give read-write access to destination backup directory
        ReadWritePaths = ["/tank/BACKUP/ente"];

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

    systemd.timers.ente-tank-backup = {
      description = "Periodically rsync Ente Photos backup to tank storage";
      partOf = ["ente-tank-backup.service"];
      wantedBy = ["timers.target"];
      timerConfig = {
        # Weekly on Wednesdays at 15:00 UTC
        OnCalendar = "Wed *-*-* 15:00:00";
        Persistent = true;
      };
    };
  };
}
