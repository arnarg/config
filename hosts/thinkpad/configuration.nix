{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    slack
    azure-cli

    # Chromium is needed for some stuff
    chromium

    # Citrix needed for some stuff
    citrix_workspace
  ];

  # Setup laptop profile.
  profiles.laptop.enable = true;
  profiles.laptop.suspendThenHibernate.enable = false;

  # Setup development profile.
  profiles.development.enable = true;

  # Setup immutable profile.
  profiles.immutable.enable = true;
  profiles.immutable.directories = [
    "/var/lib/tailscale"
  ];

  # Setup bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set TLP settings.
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    RESTORE_THRESHOLDS_ON_BAT = 1;
  };

  # Enable tailscale
  services.tailscale.enable = true;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "23.11";
}
