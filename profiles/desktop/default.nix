{ config, lib, pkgs, home, ... }:
{
  imports = [
    ./gnome
  ];


  config = with lib; {
    # Default packages for this profile
    local.desktop.gnome.enable = mkDefault true;

    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;

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
