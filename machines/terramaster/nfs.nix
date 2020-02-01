{ config, pkgs, ... }:
let
  portmapperPort = 111;
  nfsPort = 2049;
  mountdPort = 20048;
  statdPort = 32765;
  lockdPort = 32803;
in {
  # Open firewall for NFS
  networking.firewall.allowedTCPPorts = [
    portmapperPort
    nfsPort
    mountdPort
    statdPort
    lockdPort
  ];
  networking.firewall.allowedUDPPorts = [
    portmapperPort
    nfsPort
    mountdPort
    statdPort
    lockdPort
  ];

  # NFS server settings
  services.nfs.server = {
    enable = true;
    exports = ''
      /export       10.0.0.0/24(rw,sync,crossmnt,fsid=0) 10.0.100.0/24(ro,sync,crossmnt,fsid=0)
      /export/media 10.0.0.0/24(rw,async,no_root_squash) 10.0.100.0/24(rw,sync,all_squash,anonuid=3000,anongid=3000)
    '';
    mountdPort = mountdPort;
    statdPort = statdPort;
    lockdPort = lockdPort;
    nproc = 16;
  };
  
  # Mount filesystems
  fileSystems = {
    "/tank" = {
      device = "/dev/disk/by-uuid/4f87db74-309f-4256-baaa-4596a22b04e5";
      fsType = "btrfs";
      mountPoint = "/tank";
      options = [ "rw" "relatime" "space_cache" "subvolid=257" "subvol=/tank" ];
    };

    "/export/media" = {
      device = "/tank/MEDIA";
      options = [ "bind" ];
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/tank" ];
    interval = "Mon *-*-* 03:00:00";
  };
}
