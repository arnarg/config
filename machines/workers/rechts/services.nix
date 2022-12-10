{
  config,
  lib,
  pkgs,
  ...
}: {
  services.sonarr.enable = true;
  services.sonarr.dataDir = "/nix/persist/var/lib/sonarr/.config/NzbDrone";

  services.radarr.enable = true;
  services.radarr.dataDir = "/nix/persist/var/lib/radarr/.config/NzbDrone";

  local.consul.services = {
    sonarr = {
      name = "sonarr";
      port = 8989;
      connect.sidecar_service = {};
    };
    radarr = {
      name = "radarr";
      port = 7878;
      connect.sidecar_service = {};
    };
  };
  local.proxy.services = {
    sonarr.url = "http://localhost:8989";
    radarr.url = "http://localhost:7878";
  };
}
