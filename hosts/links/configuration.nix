{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    # Setup server profile.
    profiles.server.enable = true;

    ################
    ## Bootloader ##
    ################
    # According to https://nixos.wiki/wiki/NixOS_on_ARM/UEFI
    boot.loader.efi.canTouchEfiVariables = false;
    boot.loader.systemd-boot.enable = true;

    # Copy dtb to /boot
    boot.loader.systemd-boot.extraFiles = {
      "dtb/amlogic/meson-g12b-odroid-n2.dtb" =
        "${config.hardware.deviceTree.package}/amlogic/meson-g12b-odroid-n2.dtb";
    };

    # Run latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    ################
    ## Networking ##
    ################
    networking.useDHCP = false;
    networking.interfaces.eth0.useDHCP = true;

    # Firewall settings
    networking.firewall.checkReversePath = "loose";
    networking.firewall.interfaces.eth0 = {
      allowedTCPPorts = [
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
    networking.firewall.trustedInterfaces = [
      "cilium_host"
      "cilium_net"
      "cilium_vxlan"
      "lxc+"
    ];

    ###############
    ## K3s Agent ##
    ###############
    services.k3s.enable = true;
    services.k3s.role = "agent";
    services.k3s.serverAddr = "https://192.168.0.10:6443";
    services.k3s.tokenFile = "/etc/rancher/k3s/token";

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
        users = [ "arnar" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
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
      options = "--delete-older-than 3d";
    };
  };
}
