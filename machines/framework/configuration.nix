{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # For protection!
  # https://www.phoronix.com/news/Intel-iGPU-Avoid-Linux-5.19.12
  boot.kernelPackages = assert lib.assertMsg (pkgs.linuxPackages_latest.kernel.version != "5.19.12") "Linux 5.19.12 broken!";
    pkgs.linuxPackages_latest;

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
