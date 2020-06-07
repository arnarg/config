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
    waybar.config = mkOption {
      type = types.attrsOf types.unspecified;
      default = {};
      description = "Waybar config";
    };
  };

  imports = [
    ./sway-config.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mako
      numix-icon-theme
    ];

    # Use librsvg's gdk-pixbuf loader cache file as it enables gdk-pixbuf to load SVG files (important for icons)
    environment.sessionVariables = {
      GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
    };

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
        (waybar.override { pulseSupport = true; })
      ];

      # Sway
      wayland.windowManager.sway.enable = true;

      # Waybar config
      xdg.enable = true;
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

      xdg.configFile."mako/config" = {
        text = ''
          font=inconsolata ${builtins.toString (config.lib.displayScaling.floor 14)}
          background-color=#4eb5abaa
          margin=${builtins.toString (config.lib.displayScaling.floor 14)}
          padding=${builtins.toString (config.lib.displayScaling.floor 14)}
          border-radius=${builtins.toString (config.lib.displayScaling.floor 10)}
          default-timeout=5000
          width=${builtins.toString (config.lib.displayScaling.floor 350)}
          height=${builtins.toString (config.lib.displayScaling.floor 100)}
          border-size=0
          icons=1
          max-icon-size=64
          icon-path=${pkgs.numix-icon-theme}/share/icons/Numix
        '';
      };
    };
  };
}
