{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    # This breaks too often in unstable
    # so I put it here
    azure-cli
  ];

  # I haven't got hibernate to work nicely with the AMD CPU
  services.logind.lidSwitch = "suspend";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.evolution.enable = true;
  programs.evolution.plugins = [pkgs.evolution-ews];

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    RESTORE_THRESHOLDS_ON_BAT = 1;
  };

  services.tailscale.enable = true;
  environment.persistence."/nix/persist".directories = [
    "/var/lib/tailscale"
  ];

  services.avahi.enable = false;

  # I want to cross-compile
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking = {
    hostId = "7d7c4e6f";
    hostName = "thinkpad";
  };

  system.stateVersion = "22.11";
}
