{ config, lib, pkgs, ... }:
{
  config = {

    programs.gpg.enable = true;

    services.gpg-agent.enable = true;
    services.gpg-agent.pinentryFlavor = "tty";
    services.gpg-agent.enableScDaemon = false;

  };
}
