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
      type = types.str;
      default = "";
      description = "Extra sway config.";
    };
  };

  config = {
    programs.sway.enable = true;
    users.users.arnar.extraGroups = [ "sway" ];

    home-manager.users.arnar = {
      home.packages = with pkgs; [
        swayidle
        swaylock
        waybar
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
          bemenuSize = if cfg.isHiDPI then 16 else 14;
          extraConfig = cfg.sway.extraConfig;
        };
        onChange = "${reloadSway}";
      };

      xdg.configFile."waybar/style.css" = {
        text = (builtins.readFile ./conf.d/waybar.css);
        onChange = "${reloadSway}";
      };

      xdg.configFile."waybar/config" = {
        text = builtins.toJSON (
          import ./waybar-config.nix {
            inherit lib;
            isHiDPI = cfg.isHiDPI;
            isLaptop = cfg.isLaptop;
          }
        );
        onChange = "${reloadSway}";
      };
    };
  };
}
