{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop;
in with pkgs.stdenv; with lib; {
  imports = [ ./home.nix ];

  options.local.desktop = {
    isLaptop = mkOption {
      type = types.bool;
      default = false;
      description = "Enables laptop features.";
    };
  };

  config = {
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

    security.sudo.enable = true;

    users.users.arnar.extraGroups = [
      "audio"
      "cdrom"
      "input"
      "tty"
      "video"
      "dialout"
    ];

    # For yubikey
    services.pcscd.enable = true;

    home-manager.users.arnar = {
      home.packages = with pkgs; [
        capitaine-cursors
        libpulseaudio
        spotify
      ];

      home.sessionVariables = {
        GDK_BACKEND = "wayland";
        GDK_SCALE = "-1";
        XCURSOR_PATH = [ "$HOME/.nix-profile/share/icons" ];
      };

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
