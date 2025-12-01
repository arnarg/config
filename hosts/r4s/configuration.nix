{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./interfaces.nix
    ./typingmind.nix
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

    ###############
    ## Tailscale ##
    ###############
    services.tailscale.enable = true;

    #########
    ## PDS ##
    #########
    services.bluesky-pds = {
      enable = true;
      environmentFiles = [
        "/nix/persist/var/lib/pds/env"
      ];
      settings = {
        PDS_HOSTNAME = "pds.cdbrdr.com";
        PDS_DATA_DIRECTORY = "/nix/persist/var/lib/pds/data";
        PDS_BLOBSTORE_DISK_LOCATION = "/nix/persist/var/lib/pds/data/blocks";
      };
    };
    systemd.services.bluesky-pds = {
      serviceConfig.ReadWritePaths = [ "/nix/persist/var/lib/pds/data" ];
    };

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
