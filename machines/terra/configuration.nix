{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
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

    #######################
    ## Setup Fan control ##
    #######################
    # Terramaster F2-221's fan is connected to a case fan header.
    # It doesn't spin up under load so I set up fancontrol to take
    # care of this.
    local.services.fancontrol.enable = true;
    local.services.fancontrol.config = ''
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

        # Instead cilium will be deployed
        flannel-backend = "none";
        # Running on bare metal
        disable-cloud-controller = true;
        # Will run cilium with kube proxy replacement
        disable-kube-proxy = true;
        # Will run cilium for network policy enforcement
        disable-network-policy = true;
        # Don't need the helm controller
        disable-helm-controller = true;
        # Extra stuff to disable that I will deploy manually
        disable = ["traefik" "servicelb" "local-storage"];

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
