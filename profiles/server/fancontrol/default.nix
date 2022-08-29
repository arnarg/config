{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.services.fancontrol;
  fanconfig = pkgs.writeText "fancontrol.conf" cfg.config;
in
  with lib; {
    options.local.services.fancontrol = {
      enable = mkEnableOption "fancontrol";
      config = mkOption {
        type = types.str;
        default = "";
        description = "Configuration for fancontrol";
      };
    };

    config = mkIf cfg.enable {
      systemd.services.fancontrol = {
        enable = true;
        description = "Fan control";
        wantedBy = ["multi-user.target" "graphical.target" "rescue.target"];

        unitConfig.Type = "simple";

        serviceConfig.ExecStart = "${pkgs.lm_sensors}/bin/fancontrol ${fanconfig}";
        serviceConfig.Restart = "always";
      };
    };
  }
