{
  config,
  pkgs,
  ...
}: {
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
}
