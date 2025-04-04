{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hardware.fan2go;

  fan2goConfig = pkgs.writeText "fan2go.yaml" ''
    dbPath: ${cfg.dbPath}

    fans:
      - id: out_back
        hwmon:
          platform: it8613
          rpmChannel: 3
          pwmChannel: 3
        curve: case_max

    sensors:
      - id: cpu_package
        hwmon:
          platform: coretemp
          index: 1

      - id: nvme_ssd
        hwmon:
          platform: nvme
          index: 2

      - id: hdd
        hwmon:
          platform: drivetemp
          index: 1

    curves:
      - id: cpu_curve
        linear:
          sensor: cpu_package
          steps:
            - 40: 0
            - 50: 50
            - 80: 255

      - id: nvme_curve
        linear:
          sensor: nvme_ssd
          min: 40
          max: 70

      - id: hdd_curve
        linear:
          sensor: hdd
          min: 30
          max: 50

      - id: case_max
        function:
          type: maximum
          curves:
            - cpu_curve
            - nvme_curve
            - hdd_curve
  '';
in {
  options.hardware.fan2go = with lib; {
    enable = mkEnableOption "fan2go";

    dbPath = mkOption {
      type = types.str;
      default = "/var/lib/fan2go/fan2go.db";
      description = "The path of the database file.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fan2go = {
      description = "A simple daemon providing dynamic fan speed control based on temperature sensors.";
      wantedBy = ["multi-user.target"];
      after = ["lm_sensors.service"];

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          "${pkgs.fan2go}/bin/fan2go"
          "-c"
          "${fan2goConfig}"
          "--no-style"
        ];
        LimitNOFILE = 8192;
      };
    };
  };
}
