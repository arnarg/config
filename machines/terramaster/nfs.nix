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
    "/export/media" = {
      device = "/tank/MEDIA";
      options = [ "bind" ];
    };
  };
}
