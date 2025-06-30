{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    "${inputs.disko.result}/module.nix"
    ./hardware-configuration.nix
    ./disk-config.nix
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
    boot.loader.systemd-boot.enable = true;

    # Run latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    ################
    ## Networking ##
    ################
    networking.useDHCP = true;

    # Only allow SSH traffic from tailscale
    services.openssh.openFirewall = lib.mkForce false;
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
      22
    ];

    ###############
    ## Tailscale ##
    ###############
    services.tailscale.enable = true;

    #################
    ## NixOS stuff ##
    #################
    system.stateVersion = "25.05";
    nix.gc = {
      automatic = true;
      dates = "*-*-* 00:00:00";
      options = "--delete-older-than 7d";
    };
  };
}
