{
  config,
  pkgs,
  ...
}: let
  cfg = config.local.development.yubikey;
in
  with lib; {
    options.local.development.yubikey = {
      SSHHosts = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of hosts that should use yubikey-agent.";
      };
    };

    config = {
      services.gpg-agent.enableScDaemon = false;
      programs.ssh.enable = true;
      programs.ssh.matchBlocks = mkMerge (
        forEach cfg.SSHHosts (
          h: {
            "${h}".extraOptions.IdentityAgent = "$YUBIKEY_AGENT_SOCK";
          }
        )
      );
    };
  }
