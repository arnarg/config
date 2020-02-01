{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop;

  # NOTE
  # - $SWAYSOCK unavailable
  # - $(sway --get-socketpath) doesn"t work
  # A bit hacky, but since we always know our uid
  # this works consistently
  reloadSway = ''
    echo "Reloading sway"
    swaymsg -s \
    $(find /run/user/''${UID}/ \
      -name "sway-ipc.''${UID}.*.sock") \
    reload
  '';
in {
  imports = [ ./home.nix ];

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

    security.sudo.enable =true;

    users.users.arnar.extraGroups = [
      "audio"
      "cdrom"
      "input"
      "sway"
      "tty"
      "video"
    ];

    programs.sway.enable = true;

    home-manager.users.arnar = {
      home.packages = with pkgs; [
        libpulseaudio
        swayidle
        swaylock
        waybar
        xwayland

        spotify
      ];

      home.sessionVariables = {
        GDK_SCALE = "-1";
        GDK_BACKEND = "wayland";
      };

      xdg.enable = true;
      xdg.configFile."sway/config" = with pkgs; {
        source = substituteAll {
          name = "sway-config";
          src = ../conf.d/sway.conf;
          wall = "${pantheon.elementary-wallpapers}/share/backgrounds/Morskie\ Oko.jpg";
          j4 = "${j4-dmenu-desktop}/bin/j4-dmenu-desktop";
          bemenu = "${mypkgs.bemenu}/bin/bemenu";
        };
        onChange = "${reloadSway}";
      };

      xdg.configFile."waybar/config" = {
        text = (builtins.readFile ../conf.d/waybar.conf);
        onChange = "${reloadSway}";
      };
      xdg.configFile."waybar/style.css" = {
        text = (builtins.readFile ../conf.d/waybar.css);
        onChange = "${reloadSway}";
      };

      programs.alacritty = {
        enable = true;
        settings = {
          window = {
            padding.x = 6;
            padding.y = 4;
          };

          font = {
            size = 14;
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
