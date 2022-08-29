{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.development.podman;
in
  with lib; {
    options.local.development.podman = {
      enable = mkEnableOption "podman";
    };

    config = mkIf cfg.enable {
      virtualisation.podman.enable = true;
      virtualisation.podman.dockerCompat = true;

      users.users.arnar.subUidRanges = [
        {
          count = 65536;
          startUid = 100000;
        }
      ];
      users.users.arnar.subGidRanges = [
        {
          count = 65536;
          startGid = 100000;
        }
      ];
    };
  }
