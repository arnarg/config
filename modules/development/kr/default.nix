{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.kr;
  userName = config.local.userName;
in with pkgs.stdenv; with lib; {
  options.local.development.kr = {
    enable = mkEnableOption "kr";
  };

  config = mkIf cfg.enable {
      
    home-manager.users.${userName} = {
      home.packages = [ pkgs.mypkgs.kr ];

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
