{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.services.w4-bin = {
    description = "a paste bin";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${pkgs.w4-bin}/bin/bin 127.0.0.1:8820";

      DynamicUser = true;
      StateDirectory = "w4-bin";
      # As the RootDirectory
      RuntimeDirectory = "w4-bin";

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
      RootDirectory = "/run/w4-bin";
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
}
