{
  config,
  pkgs,
  lib,
  inputs,
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

  # Enable tailscale
  services.tailscale.enable = true;

  # Having resolved with a networkmanager setup helps with resolv.conf handling
  # when using tailscale dns
  services.resolved.enable = true;

  # Persist fingerprints
  environment.persistence."/nix/persist".directories = [
    "/var/lib/fprint"
    "/var/lib/tailscale"
  ];

  # Disable fingerprint pam auth
  security.pam.services.login.fprintAuth = false;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking = {
    hostId = "ba0a056f";
    hostName = "framework";
  };

  system.stateVersion = "22.05";
}
