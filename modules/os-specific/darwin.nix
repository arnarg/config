{ config, lib, ... }:
let
  cfg = config.local;
in with lib; {
  config = {
    # Run krd
    launchd.user.agents.krd = mkIf cfg.development.kr.enable {
      serviceConfig.ProgramArguments = [ "${pkgs.mypkgs.kr}/bin/krd" ];
      serviceConfig.Label = "co.krypt.krd";
      serviceConfig.RunAtLoad = true;
    };
  }
}
