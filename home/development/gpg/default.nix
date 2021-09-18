{ config, lib, pkgs, ... }:
with lib; {
  config = {

    programs.gpg.enable = true;

    services.gpg-agent.enable = mkIf pkgs.stdenv.isLinux true;
    services.gpg-agent.pinentryFlavor = "tty";
    services.gpg-agent.enableScDaemon = false;

  };
}
