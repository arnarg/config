{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.desktop;
in {
  options.profiles.desktop.tpm-fido = with lib; {
    enable = mkEnableOption "tpm-fido";
  };

  config = lib.mkIf (cfg.enable && cfg.tpm-fido.enable) {
    systemd.user.services.tpm-fido = {
      Unit = {
        Description = "TPM Fido";
      };
      Service = {
        Environment = "PATH=${pkgs.pinentry-gnome}/bin/";
        ExecStart = "${pkgs.tpm-fido}/bin/tpm-fido";
        Restart = "always";
        RestartSec = 10;
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
