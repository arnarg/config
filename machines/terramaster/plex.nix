{ config, pkgs, ... }:

{
  services.plex.enable = true;
  services.plex.openFirewall = true;
  services.plex.dataDir = "/external/plex";
  services.plex.managePlugins = false;

  fileSystems = {
    "/external" = {
      device = "/dev/disk/by-label/external";
      fsType = "ext4";
      mountPoint = "/external";
    };
  };
}
