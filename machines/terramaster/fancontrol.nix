{ config, pkgs, ... }:

{
  # Terramaster F2-221's fan is connected to a case fan header.
  # It doesn't spin up under load so I set up fancontrol to take care of this.
  systemd.services.fancontrol = {
    enable = true;
    description = "Fan control";
    wantedBy = ["multi-user.target" "graphical.target" "rescue.target"];

    unitConfig = {
      Type = "simple";
    };

    serviceConfig = {
      ExecStart = "${pkgs.lm_sensors}/bin/fancontrol";
      Restart = "always";
    };
  };

  # Because of the order in boot.kernelModules coretemp is always loaded before it87.
  # This makes hwmon0 coretemp and hwmon1 it8613e (acpitz is hwmon2).
  # This seems to be consistent between reboots.
  environment.etc.fancontrol = {
    text = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon1=devices/platform/it87.2592
      DEVNAME=hwmon0=coretemp hwmon1=it8613
      FCTEMPS=hwmon1/pwm3=hwmon0/temp1_input
      FCFANS= hwmon1/pwm3=hwmon1/fan3_input
      MINTEMP=hwmon1/pwm3=20
      MAXTEMP=hwmon1/pwm3=60
      MINSTART=hwmon1/pwm3=52
      MINSTOP=hwmon1/pwm3=12
    '';
    mode = "444";
  };
}
