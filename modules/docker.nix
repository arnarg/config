{ config, lib, pkgs, ... }:
let
  userName = config.local.home.userName;
in {
  config = {
    virtualisation.docker.enable = true;
    virtualisation.docker.autoPrune.enable = true;

    users.users.${userName}.extraGroups = [ "docker" ];
  };
}
