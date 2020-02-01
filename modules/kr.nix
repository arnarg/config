{ config, lib, pkgs, ... }:
let
  userName = config.local.home.userName;
in with pkgs.stdenv; with lib; {
  config = {
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
