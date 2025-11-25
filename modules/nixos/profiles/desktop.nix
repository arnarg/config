{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
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

    # Use Gnome wayland.
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
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
