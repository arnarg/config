{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.sway;

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
    enable = mkEnableOption "sway";
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra sway config.";
    };
    waybar.config = mkOption {
      type = types.attrsOf types.unspecified;
      default = {};
      description = "Waybar config";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mako
    ];

    programs.sway.enable = true;
    users.users.arnar.extraGroups = [ "sway" ];

    local.desktop.sway.waybar.config = import ./waybar-config.nix {
      inherit lib;
      inherit pkgs;
      displayScalingLib = config.lib.displayScaling;
      isLaptop = config.local.laptop.enable;
    };


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
          bemenuSize = config.lib.displayScaling.floor 12;
          desktopScripts = "${mypkgs.desktop-scripts}";
          extraConfig = cfg.extraConfig;
        };
        onChange = "${reloadSway}";
      };

      xdg.configFile."waybar/style.css" = with pkgs; {
        source = substituteAll {
          name = "waybar-css";
          src = ./conf.d/waybar.css;
          fontSize = config.lib.displayScaling.floor 12;
        };
        onChange = "${reloadSway}";
      };

      xdg.configFile."waybar/config" = {
        text = builtins.toJSON config.local.desktop.sway.waybar.config;
        onChange = "${reloadSway}";
      };
    };
  };
}
