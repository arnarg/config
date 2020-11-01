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
    programs.gnupg.agent.pinentryFlavor = "qt";

    services.yubikey-agent.enable = true;

    environment.sessionVariables = mkMerge [
      {
        YUBIKEY_AGENT_SOCK = "\${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent.sock";
      }
      # Here I make the assumption that if yubikey shouldn't be the default agent
      # it should be ssh-agent
      (mkIf (cfg.defaultAuthSock == false) {
        SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/ssh-agent";
      })
    ];
      
    home-manager.users.arnar = {
      programs.ssh.enable = true;
      programs.ssh.matchBlocks = mkMerge (
        forEach cfg.SSHHosts (h:
          {
            "${h}".extraOptions.IdentityAgent = "$YUBIKEY_AGENT_SOCK";
          }
        )
      );
    };

  };

}
