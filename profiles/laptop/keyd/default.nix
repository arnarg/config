{
  config,
  lib,
  ...
}: let
  cfg = config.local.laptop.keyd;
in
  with lib; {
    options.local.laptop.keyd = {
      enable = mkEnableOption "keyd";
      inputDevices = mkOption {
        type = types.listOf types.str;
        default = ["0001:0001"];
      };
    };

    config = mkIf cfg.enable {
      services.keyd.enable = true;
      services.keyd.ids = cfg.inputDevices;

      # This mimics my mechanical keyboard with QMK firmware
      # on my laptop keyboards.
      # - Capslock is a navigation layer for various functions.
      # - Grave is escape except in the navigation layer where
      #   it's actually grave. Also shift+grave is still tilde.
      services.keyd.settings = {
        main = {
          grave = "esc";
          capslock = "layer(nav)";
        };

        nav = {
          grave = "grave";
          backspace = "delete";
          # Arrow navigation
          w = "up";
          s = "down";
          a = "left";
          d = "right";
          # Media controls
          z = "previoussong";
          x = "playpause";
          c = "nextsong";
          v = "volumedown";
          b = "volumeup";
          n = "mute";
        };

        shift = {
          grave = "S-grave";
        };
      };
    };
  }
