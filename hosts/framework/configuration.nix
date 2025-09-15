{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${inputs.hardware.result}/framework/13-inch/12th-gen-intel"
  ];

  # Switch to stable kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # Setup laptop profile.
  profiles.laptop.enable = true;
  profiles.laptop.plymouth.enable = true;

  # Setup development profile.
  profiles.development.enable = true;

  # Setup immutable profile.
  profiles.immutable.enable = true;
  profiles.immutable.directories = [
    "/var/lib/fprint"
    "/var/lib/tailscale"
  ];

  # Setup TPM profile.
  profiles.tpm.enable = true;

  # framework kmod is not building
  # and I'm not really using it
  hardware.framework.enableKmod = false;

  # Setup bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup tailscale.
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # Disable fingerprint pam auth
  security.pam.services.login.fprintAuth = false;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "24.05";
}
