{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.gpg;
in with lib; {
  options.local.development.gpg = {
    enable = mkEnableOption "gpg";
  };

  config = mkIf cfg.enable {

    home-manager.users.arnar = {
      programs.gpg.enable = true;

      services.gpg-agent.enable = true;
      services.gpg-agent.pinentryFlavor = "tty";
    };

  };
}
