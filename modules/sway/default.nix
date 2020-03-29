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
in with pkgs.stdenv; with lib; {
  options.local.desktop.sway = {
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra sway config.";
    };
    waybar.extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra waybar config.";
    };
  };

  config = {
    programs.sway.enable = true;
    users.users.arnar.extraGroups = [ "sway" ];

    fonts.fonts = [ pkgs.font-awesome ];

    home-manager.users.arnar = {
      home.packages = with pkgs; [
        swayidle
        swaylock
        (waybar.override { pulseSupport = true; })
        xwayland
      ];

      xdg.enable = true;
      xdg.configFile."sway/config" = with pkgs; {
        source = substituteAll {
          name = "sway-config";
          src = ./conf.d/sway.conf;
          wall = "${pantheon.elementary-wallpapers}/share/backgrounds/Morskie\ Oko.jpg";
          j4 = "${j4-dmenu-desktop}/bin/j4-dmenu-desktop";
          bemenu = "${mypkgs.bemenu}/bin/bemenu";
          bemenuSize = if cfg.isHiDPI then 14 else 12;
          extraConfig = cfg.sway.extraConfig;
        };
        onChange = "${reloadSway}";
      };

      xdg.configFile."waybar/style.css" = with pkgs; {
        source = substituteAll {
          name = "waybar-css";
          src = ./conf.d/waybar.css;
          fontSize = if cfg.isHiDPI then 14 else 12;
        };
        onChange = "${reloadSway}";
      };

      xdg.configFile."waybar/config" = {
        text = builtins.toJSON (
          import ./waybar-config.nix {
            inherit lib;
            isHiDPI = cfg.isHiDPI;
            isLaptop = cfg.isLaptop;
            extraConfig = cfg.sway.waybar.extraConfig;
          }
        );
        onChange = "${reloadSway}";
      };
    };
  };
}
