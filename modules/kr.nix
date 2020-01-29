{ config, lib, pkgs, ... }:
let
  userName = config.local.home.userName;
in {
  config = {
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
