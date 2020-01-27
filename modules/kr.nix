{ config, lib, pkgs, ... }:
let
  userName = config.local.home.userName;
  mypkgs = import ../packages { inherit pkgs; };
in {
  config = {
    home-manager.users.${userName} = {
      home.packages = [ mypkgs.kr ];

      #systemd.user.services.krd = {
      #  Unit = {
      #    Description = "Krypton daemon";
      #  };

      #  Service = {
      #    ExecStart = "${mypkgs.kr}/bin/krd";
      #    Restart = "on-failure";
      #  };

      #  Install = {
      #    WantedBy = "default.target";
      #  };
      #};

      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        "*" = {
          proxyCommand = "${mypkgs.kr}/bin/krssh %h %p";
          identityFile = "~/.ssh/id_krypton.pub";
          extraOptions.IdentityAgent = "~/.kr/krd-agent.sock";
        };
      };
    };
  };
}
