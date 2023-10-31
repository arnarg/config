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
    networking.hostName = "rechts";

    time.timeZone = "utc";

    ################
    ## Bootloader ##
    ################
    # According to https://nixos.wiki/wiki/NixOS_on_ARM/UEFI
    boot.loader.efi.canTouchEfiVariables = false;
    boot.loader.systemd-boot.enable = true;

    # Run latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    ################
    ## Networking ##
    ################
    networking.useDHCP = false;
    networking.interfaces.eth0.useDHCP = true;

    # Enable SSH server
    services.openssh.enable = true;

    ###############
    ## K3s Agent ##
    ###############
    services.k3s.enable = true;
    services.k3s.role = "agent";
    services.k3s.serverAddr = "https://192.168.0.10:6443";
    services.k3s.tokenFile = "/etc/rancher/k3s/token";
    services.k3s.extraFlags = let
      # Config options for k3s agent
      agentConfig = pkgs.writeText "k3s-config.yaml" (lib.generators.toYAML {} {
        # Don't schedule workloads until cilium is ready
        node-taint = [
          "node.cilium.io/agent-not-ready=true:NoSchedule"
        ];
      });
    in "--config ${agentConfig}";

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
    system.stateVersion = "23.05";
    nix.gc = {
      automatic = true;
      dates = "*-*-* 00:00:00";
      options = "--delete-older-than 3d";
    };
  };
}
