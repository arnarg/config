{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Persist fingerprints
  environment.persistence."/nix/persist".directories = [
    "/var/lib/fprint"
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
