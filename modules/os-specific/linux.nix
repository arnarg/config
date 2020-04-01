{ config, lib, pkgs, ... }:
let
  cfg = config.local;
in with lib; {
  imports = [
    ../users
  ];

  config = {
    programs.zsh.syntaxHighlighting = mkIf cfg.development.zsh.enable { enable = true; };

    home-manager.users.${cfg.userName} = {
      
      # Run krd
      systemd.user.services.krd = mkIf cfg.development.kr.enable {
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
