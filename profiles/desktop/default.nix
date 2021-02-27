{ config, lib, pkgs, ... }:
{
  imports = [
    ./firefox
    ./qutebrowser
    ./spotify
    ./sway
    ./syncthing
  ];

  config = with lib; {
    # Default packages for this profile
    local.desktop.firefox.enable = mkDefault true;
    local.desktop.qutebrowser.enable = mkDefault true;
    local.desktop.spotify.enable = mkDefault true;
    local.desktop.sway.enable = mkDefault true;

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

    home-manager.users.arnar = {
      home.packages = with pkgs; [
        capitaine-cursors
        libpulseaudio
      ];

      programs.alacritty = {
        enable = true;
        settings = {
          window = {
            padding.x = 6;
            padding.y = 4;
          };

          font = {
            size = config.lib.displayScaling.floor 12;
            normal.family = "Inconsolata";
          };

          # One Dark
          colors = {
            primary = {
              background = "0x282c34";
              foreground = "0xabb2bf";
            };

            normal = {
              black = "0x282c34";
              red = "0xe06c75";
              green = "0x98c379";
              yellow = "0xd19a66";
              blue = "0x61afef";
              magenta = "0xc678dd";
              cyan = "0x56b6c2";
              white = "0xabb2bf";
            };

            bright = {
              black = "0x5c6370";
              red = "0xe06c75";
              green = "0x98c379";
              yellow = "0xd19a66";
              blue = "0x61afef";
              magenta = "0xc678dd";
              cyan = "0x56b6c2";
              white = "0xffffff";
            };
          };
        };
      };
    };
  };
} 
