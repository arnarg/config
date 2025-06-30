{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.desktop;
in {
  options.profiles.desktop = with lib; {
    enable = mkEnableOption "desktop profile";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      home-manager
    ];

    # Use latest kernel.
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    # Use lix instead of nix
    nix.package = pkgs.lix;

    # Use Gnome wayland.
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
    };

    # Use pipewire instead of pulseaudio for sound.
    services.pipewire.enable = true;
    services.pipewire.pulse.enable = true;

    # Enable graphics.
    hardware.graphics.enable = true;

    # Setup system fonts.
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        inconsolata
        powerline-fonts
      ];
    };

    # Enable pcscd for use with yubikey-manager.
    services.pcscd.enable = true;

    # Extra groups for user "arnar" on desktops.
    users.users.arnar.extraGroups = [
      "audio"
      "cdrom"
      "input"
      "tty"
      "video"
      "dialout"
    ];

    # Desktops get "Europe/Vienna" timezone.
    time.timeZone = lib.mkForce "Europe/Vienna";
  };
}
