{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./interfaces.nix
  ];

  config = {
    # Setup server profile.
    profiles.server.enable = true;

    # Setup immutable profile.
    profiles.immutable.enable = true;
    profiles.immutable.directories = [
      "/var/lib/tailscale"
    ];

    ################
    ## Bootloader ##
    ################
    # According to https://nixos.wiki/wiki/NixOS_on_ARM/UEFI
    boot.loader.efi.canTouchEfiVariables = false;
    boot.loader.systemd-boot.enable = true;
    boot.loader.timeout = 2;

    # Run latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    ################
    ## Networking ##
    ################
    networking.useDHCP = false;
    networking.interfaces.wan0.useDHCP = true;

    # Firewall settings
    networking.firewall.checkReversePath = "loose";
    networking.firewall.interfaces.wan0 = {
      allowedTCPPorts = [
        # K3s api server
        6443
        # Kubelet port
        10250
        # Cilium health checks
        4240
      ];
      allowedUDPPorts = [
        # Cilium VXLAN
        8472
      ];
    };
    # Also allow tailscale to access k3s api server
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [6443];
    networking.firewall.trustedInterfaces = [
      "cilium_host"
      "cilium_net"
      "cilium_vxlan"
      "lxc+"
    ];

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
        disable = ["traefik" "servicelb" "local-storage" "metrics-server"];

        # Don't schedule workloads on the server
        node-taint = [
          "node.kubernetes.io/control-plane:NoSchedule"
        ];

        # Add kube apiserver flags
        kube-apiserver-arg = [
          # Set admission control config
          "admission-control-config-file=${admissionControlConfig}"
          # Allow anonymous auth for OIDC discovery URL
          "anonymous-auth=true"
        ];
      });
    in "--config ${serverConfig}";

    ###############
    ## Tailscale ##
    ###############
    services.tailscale.enable = true;

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
    system.stateVersion = "23.11";
    nix.gc = {
      automatic = true;
      dates = "*-*-* 00:00:00";
      options = "--delete-older-than 7d";
    };
  };
}
