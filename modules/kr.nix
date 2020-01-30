{ config, lib, pkgs, ... }:
let
  cfg = config.services.krypton;
  userName = config.local.home.userName;
in with pkgs.stdenv; with lib; {
  options = {
    services.krypton.krd.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable krd service";
    };
  };

  config = {
    launchd.user.agents.krd = mkIf isDarwin (mkIf cfg.krd.enable {
      serviceConfig.ProgramArguments = [ "${pkgs.mypkgs.kr}/bin/krd" ];
      serviceConfig.Label = "co.krypt.krd";
      serviceConfig.RunAtLoad = true;
    });

    home-manager.users.${userName} = {
      home.packages = [ pkgs.mypkgs.kr ];

      #systemd.user.services.krd = {
      #  Unit = {
      #    Description = "Krypton daemon";
      #  };

      #  Service = {
      #    ExecStart = "${pkgs.mypkgs.kr}/bin/krd";
      #    Restart = "on-failure";
      #  };

      #  Install = {
      #    WantedBy = "default.target";
      #  };
      #};

      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        "*" = {
          proxyCommand = "${pkgs.mypkgs.kr}/bin/krssh %h %p";
          identityFile = "~/.ssh/id_krypton.pub";
          extraOptions.IdentityAgent = "~/.kr/krd-agent.sock";
        };
      };
    };
  };
}
