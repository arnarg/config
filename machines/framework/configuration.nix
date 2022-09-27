{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # DNS over HTTPS
  services.nextdns.enable = true;
  services.nextdns.arguments = [
    "-config-file"
    "/nix/persist/etc/nextdns/nextdns.conf"
    "-auto-activate"
  ];

  # Persist fingerprints
  environment.persistence."/nix/persist".directories = [
    "/var/lib/fprint"
  ];

  networking = {
    hostId = "ba0a056f";
    hostName = "framework";
  };

  system.stateVersion = "22.05";
}
