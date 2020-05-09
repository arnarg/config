{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.kr;
in with pkgs.stdenv; with lib; {
  options.local.development.kr = {
    enable = mkEnableOption "kr";
  };

  config = mkIf cfg.enable {
      
    home-manager.users.arnar = {
      home.packages = [ pkgs.mypkgs.kr ];

      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        "*" = {
          proxyCommand = "${pkgs.mypkgs.kr}/bin/krssh %h %p";
          identityFile = "~/.ssh/id_krypton.pub";
          extraOptions.IdentityAgent = "~/.kr/krd-agent.sock";
        };
      };

      # Run krd
      systemd.user.services.krd = {
        Unit = {
          Description = "Krypton daemon";
        };
        Service = {
          ExecStart = "${pkgs.mypkgs.kr}/bin/krd";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };

  };

}
