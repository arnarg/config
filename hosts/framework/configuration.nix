{...}: {
  imports = [
    ./hardware-configuration.nix
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

  # Setup bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup tailscale.
  services.tailscale.enable = true;

  # Disable fingerprint pam auth
  security.pam.services.login.fprintAuth = false;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "24.05";
}
