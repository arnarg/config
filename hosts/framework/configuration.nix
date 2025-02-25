{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    logseq
  ];

  # For logseq
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];

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

  # Setup NAS NFS mount
  fileSystems."/media/storage" = {
    device = "192.168.0.10:/exports/storage";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=120"];
  };

  # Setup tailscale.
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # Disable fingerprint pam auth
  security.pam.services.login.fprintAuth = false;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "24.05";
}
