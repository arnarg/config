{
  config,
  lib,
  pkgs,
  home,
  ...
}: {
  imports = [
    ./gnome
    ./kde
  ];

  config = with lib; {
    # Default packages for this profile
    local.desktop.gnome.enable = mkDefault true;

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire.enable = true;
    services.pipewire.pulse.enable = true;

    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        inconsolata
        powerline-fonts
      ];
    };

    users.users.arnar.extraGroups = [
      "audio"
      "cdrom"
      "input"
      "tty"
      "video"
      "dialout"
    ];

    time.timeZone = mkForce "Europe/Vienna";
  };
}
