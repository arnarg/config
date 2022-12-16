{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    RESTORE_THRESHOLDS_ON_BAT = 1;
  };

  services.tailscale.enable = true;

  services.avahi.enable = false;

  networking = {
    hostId = "7d7c4e6f";
    hostName = "thinkpad";
  };

  system.stateVersion = "22.11";
}
