{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.docker;
in with lib; {
  options.local.development.docker = {
    enable = mkEnableOption "docker";
  };

  config = mkIf cfg.enable {
    
    virtualisation.docker.enable = true;
    virtualisation.docker.autoPrune.enable = true;

    users.users.arnar.extraGroups = [ "docker" ];

  };
}
