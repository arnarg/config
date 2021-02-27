{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.homehosts;
in with lib; {
  options.local.development.homehosts = {
    enable = mkEnableOption "homehosts";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.mypkgs.libnss_homehosts}/lib:$LD_LIBRARY_PATH";
    };
    services.nscd.enable = true;
    system.nssModules = [ pkgs.mypkgs.libnss_homehosts ];
    system.nssDatabases.hosts = mkBefore [ "homehosts" ];
  };
}
