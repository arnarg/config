{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.tpm;
in
{
  options.profiles.tpm = with lib; {
    enable = mkEnableOption "tpm profile";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "uhid" ];

    users.users.tss = {
      name = "tss";
      group = "tss";
      isSystemUser = true;
    };
    users.groups.tss.name = "tss";
    users.groups.uhid.name = "uhid";

    users.users.arnar.extraGroups = [
      "tss"
      "uhid"
    ];

    services.udev.extraRules = ''
      # tpm devices can only be accessed by the tss user but the tss
      # group members can access tpmrm devices
      KERNEL=="tpm[0-9]*", TAG+="systemd", MODE="0660", OWNER="tss"
      KERNEL=="tpmrm[0-9]*", TAG+="systemd", MODE="0660", OWNER="tss", GROUP="tss"

      # uhid group can access /dev/uhid
      KERNEL=="uhid", SUBSYSTEM=="misc", MODE="0660", GROUP="uhid"
    '';
  };
}
