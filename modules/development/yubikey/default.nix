{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.yubikey;
in with pkgs.stdenv; with lib; {
  options.local.development.yubikey = {
    enable = mkEnableOption "yubikey";
    defaultAuthSock = mkOption {
      type = types.bool;
      default = true;
      description = "Whether or not to set yubikey-agent as default SSH agent.";
    };
    SSHHosts = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of hosts that should use yubikey-agent.";
    };
  };

  config = mkIf cfg.enable {

    services.pcscd.enable = true;

    environment.sessionVariables = {
      YUBIKEY_AGENT_SOCK = "\${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent.sock";
    };
      
    home-manager.users.arnar = {
      home.packages = [ pkgs.mypkgs.yubikey-agent pkgs.pinentry-qt ];

      programs.ssh.enable = true;
      programs.ssh.matchBlocks = mkMerge (
        forEach cfg.SSHHosts (h:
          {
            "${h}".extraOptions.IdentityAgent = "$YUBIKEY_AGENT_SOCK";
          }
        )
      );

      programs.zsh.sessionVariables = mkIf cfg.defaultAuthSock {
        SSH_AUTH_SOCK = "\${YUBIKEY_AGENT_SOCK}";
      };

      # Run yubikey-agent
      systemd.user.services.yubikey-agent = {
        Unit = {
          Description = "Yubikey agent";
        };
        Service = {
          ExecStart = "${pkgs.mypkgs.yubikey-agent}/bin/yubikey-agent -l %t/yubikey-agent/yubikey-agent.sock";
          ExecReload = "${pkgs.utillinux}/bin/kill -HUP $MAINPID";
          ProtectSystem = "strict";
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectClock = true;
          ProtectHostname = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          IPAddressDeny = "any";
          RestrictAddressFamilies = "AF_UNIX";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          CapabilityBoundingSet = "";
          SystemCallErrorNumber = "EPERM";
          SystemCallArchitectures = "native";
          NoNewPrivileges = true;
          KeyringMode = "private";
          UMask = "0177";
          RuntimeDirectory = "yubikey-agent";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };

  };

}
