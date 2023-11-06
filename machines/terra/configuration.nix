{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./services.nix
    ./hardware-configuration.nix
  ];

  config = {
    networking.hostName = "terra";

    ################
    ## Bootloader ##
    ################
    boot.loader.systemd-boot.enable = true;
    # I'm booting from an external USB drive so I
    # prefer not touching the EFI variables
    boot.loader.efi.canTouchEfiVariables = false;

    ################
    ## Networking ##
    ################
    networking.useDHCP = false;
    networking.interfaces.enp1s0.useDHCP = true;

    # My DNS has rebinding protection and Plex doesn't like that
    networking.nameservers = ["1.1.1.1" "1.0.0.1"];

    # Firewall settings
    networking.firewall.checkReversePath = "loose";
    networking.firewall.interfaces.enp1s0.allowedTCPPorts = [
      # K3s api server
      6443
      # Kubelet port
      10250
      # NFS Server
      2049
      # PostgreSQL Server
      5432
    ];
    networking.firewall.interfaces.enp1s0.allowedUDPPorts = [
      # Flannel VXLAN
      8472
    ];

    #######################
    ## Setup Fan control ##
    #######################
    # Terramaster F2-221's fan is connected to a case fan header.
    # It doesn't spin up under load so I set up fancontrol to take
    # care of this.
    hardware.fancontrol.enable = true;
    hardware.fancontrol.config = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon1=devices/platform/it87.2592
      DEVNAME=hwmon0=coretemp hwmon1=it8613
      FCTEMPS=hwmon1/pwm3=hwmon0/temp1_input
      FCFANS=hwmon1/pwm3=hwmon1/fan3_input
      MINTEMP=hwmon1/pwm3=50
      MAXTEMP=hwmon1/pwm3=80
      MINSTART=hwmon1/pwm3=52
      MINSTOP=hwmon1/pwm3=12
    '';

    ###################
    ## Setup hd-idle ##
    ###################
    systemd.services.hd-idle = {
      description = "Hard Disk Idle Spin-Down Utility";
      wantedBy = ["multi-user.target"];

      serviceConfig.ExecStart = lib.concatStringsSep " " [
        "${pkgs.hd-idle}/bin/hd-idle"
        "-i 0"
        "-c ata"
        "-a /dev/disk/by-id/ata-ST4000VN008-2DR166_ZDH0SPM0"
        "-i 1800"
        "-a /dev/disk/by-id/ata-ST4000VN008-2DR166_ZDH0XSZT"
        "-i 1800"
      ];
    };

    # hd-idle needs to be stopped while btrfs scrub is running
    systemd.services.btrfs-scrub-tank = {
      # Conflicts with hd-idle
      conflicts = ["hd-idle.service"];

      # Always restart hd-idle
      unitConfig.OnFailure = ["hd-idle.service"];
      unitConfig.OnSuccess = ["hd-idle.service"];
    };

    ################
    ## K3s Server ##
    ################
    services.k3s.enable = true;
    services.k3s.role = "server";
    services.k3s.extraFlags = let
      # Addmission control config for k3s cluster
      admissionControlConfig = pkgs.writeText "k3s-admission-control-config.yaml" ''
        apiVersion: apiserver.config.k8s.io/v1
        kind: AdmissionConfiguration
        plugins:
        - name: PodSecurity
          configuration:
            apiVersion: pod-security.admission.config.k8s.io/v1beta1
            kind: PodSecurityConfiguration
            defaults:
              enforce: "baseline"
              enforce-version: "latest"
              audit: "restricted"
              audit-version: "latest"
              warn: "restricted"
              warn-version: "latest"
            exemptions:
              usernames: []
              runtimeClasses: []
              namespaces: [kube-system]
      '';

      # Config options for k3s server
      serverConfig = pkgs.writeText "k3s-config.yaml" (lib.generators.toYAML {} {
        # Use persisted data directory
        data-dir = "/nix/persist/var/lib/rancher/k3s";

        # Running on bare metal
        disable-cloud-controller = true;
        # Don't need the helm controller
        disable-helm-controller = true;
        # Extra stuff to disable that I will deploy manually
        disable = ["traefik" "servicelb" "local-storage" "metrics-server"];

        # Don't schedule workloads on the server
        node-taint = [
          "node.kubernetes.io/control-plane:NoSchedule"
        ];

        # Add kube apiserver flags
        kube-apiserver-arg = [
          # Set admission control config
          "admission-control-config-file=${admissionControlConfig}"
        ];
      });
    in "--config ${serverConfig}";

    ################
    ## NFS Server ##
    ################
    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
      /exports/kubernetes 192.168.0.148(rw,sync,no_root_squash)
    '';
    services.nfs.server.createMountPoints = true;

    #######################
    ## PostgreSQL Server ##
    #######################
    services.postgresql.enable = true;
    services.postgresql.enableTCPIP = true;
    services.postgresql.authentication = ''
      host sameuser +ext 192.168.0.0/24 scram-sha-256
    '';

    #######################
    ## Plex Media Server ##
    #######################
    services.plex.enable = true;
    services.plex.openFirewall = true;

    ###############
    ## Tailscale ##
    ###############
    services.tailscale.enable = true;

    #######################
    ## State persistence ##
    #######################
    environment.persistence."/nix/persist".directories = [
      "/var/lib/tailscale"
      "/var/lib/plex"
      "/var/lib/postgresql"
      "/exports"
    ];

    ##########
    ## Sudo ##
    ##########
    # So I can use nixos-rebuild with --use-remote-sudo
    # TODO: Figure out how to allow less commands
    security.sudo.extraRules = [
      {
        users = ["arnar"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    #################
    ## NixOS stuff ##
    #################
    system.stateVersion = "23.05";
    nix.gc = {
      automatic = true;
      dates = "Mon *-*-* 04:00:00";
      options = "--delete-older-than 35d";
    };
  };
}
