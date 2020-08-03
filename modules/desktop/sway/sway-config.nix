{ pkgs, config, ... }:
let

  cfg = config.home-manager.users.arnar.wayland.windowManager.sway;

  bindings = {
    "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal}";
    "${cfg.config.modifier}+Shift+q" = "kill";
    "${cfg.config.modifier}+space" = "exec ${cfg.config.menu}";

    "${cfg.config.modifier}+${cfg.config.left}" = "focus left";
    "${cfg.config.modifier}+${cfg.config.down}" = "focus down";
    "${cfg.config.modifier}+${cfg.config.up}" = "focus up";
    "${cfg.config.modifier}+${cfg.config.right}" = "focus right";

    "${cfg.config.modifier}+Shift+${cfg.config.left}" = "move left";
    "${cfg.config.modifier}+Shift+${cfg.config.down}" = "move down";
    "${cfg.config.modifier}+Shift+${cfg.config.up}" = "move up";
    "${cfg.config.modifier}+Shift+${cfg.config.right}" = "move right";

    "${cfg.config.modifier}+b" = "splith";
    "${cfg.config.modifier}+v" = "splitv";
    "${cfg.config.modifier}+f" = "fullscreen toggle";
    "${cfg.config.modifier}+a" = "focus parent";

    "${cfg.config.modifier}+s" = "layout stacking";
    "${cfg.config.modifier}+w" = "layout tabbed";
    "${cfg.config.modifier}+e" = "layout toggle split";

    "${cfg.config.modifier}+Shift+space" = "floating toggle";

    "${cfg.config.modifier}+1" = "workspace number 1";
    "${cfg.config.modifier}+2" = "workspace number 2";
    "${cfg.config.modifier}+3" = "workspace number 3";
    "${cfg.config.modifier}+4" = "workspace number 4";
    "${cfg.config.modifier}+5" = "workspace number 5";
    "${cfg.config.modifier}+6" = "workspace number 6";
    "${cfg.config.modifier}+7" = "workspace number 7";
    "${cfg.config.modifier}+8" = "workspace number 8";
    "${cfg.config.modifier}+9" = "workspace number 9";

    "${cfg.config.modifier}+Shift+1" =
      "move container to workspace number 1";
    "${cfg.config.modifier}+Shift+2" =
      "move container to workspace number 2";
    "${cfg.config.modifier}+Shift+3" =
      "move container to workspace number 3";
    "${cfg.config.modifier}+Shift+4" =
      "move container to workspace number 4";
    "${cfg.config.modifier}+Shift+5" =
      "move container to workspace number 5";
    "${cfg.config.modifier}+Shift+6" =
      "move container to workspace number 6";
    "${cfg.config.modifier}+Shift+7" =
      "move container to workspace number 7";
    "${cfg.config.modifier}+Shift+8" =
      "move container to workspace number 8";
    "${cfg.config.modifier}+Shift+9" =
      "move container to workspace number 9";

    "${cfg.config.modifier}+Shift+c" = "reload";
    "${cfg.config.modifier}+Shift+e" =
      "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

    "${cfg.config.modifier}+r" = "mode resize";

    "${cfg.config.modifier}+t" = "exec ${pkgs.mypkgs.desktop-scripts}/waybar/lang.sh switch 1";
    "${cfg.config.modifier}+q" = "exec ${lockCommand}";
  };

  lockCommand = "${pkgs.swaylock-fancy}/bin/swaylock-fancy -p -f Inconsolata-Bold";

in {
  home-manager.users.arnar.wayland.windowManager.sway = {
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";

      menu = let
        j4 = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop";
        bemenu = "${pkgs.bemenu}/bin/bemenu";
      in "${j4} --dmenu=\"${bemenu} -ibp '>' --tb '#4eb5ab' --tf '#181b21' --fb '#181b21' --nb '#181b21' --hb '#4eb5ab' --hf '#181b21' --fn 'inconsolata ${builtins.toString (config.lib.displayScaling.floor 12)}' -m all\" | xargs swaymsg exec";

      ############
      ## COLORS ##
      ############
      colors = {
        focused = {
          border = "#4eb5ab";
          background = "#4eb5ab";
          text = "#232D30";
          indicator = "#6DEDE1";
          childBorder = "#4eb5ab";
        };
        focusedInactive = {
          border = "#232D30";
          background = "#232D30";
          text = "#A4A7AB";
          indicator = "#232D30";
          childBorder = "#232D30";
        };
        unfocused = {
          border = "#232D30";
          background = "#232D30";
          text = "#A4A7AB";
          indicator = "#232D30";
          childBorder = "#232D30";
        };
        urgent = {
          border = "#EB6067";
          background = "#EB6067";
          text = "#A4A7AB";
          indicator = "#EB6067";
          childBorder = "#EB6067";
        };
      };

      ##########
      ## GAPS ##
      ##########
      gaps = {
        inner = 6;
        outer = 0;
      };

      #################
      ## KEYBINDINGS ##
      #################
      keybindings = bindings;

      ##################
      ## INPUT/OUTPUT ##
      ##################
      output = {
        "*" = { bg = "${pkgs.pantheon.elementary-wallpapers}/share/backgrounds/Morskie\ Oko.jpg fill"; };
      };

      input = {
        "*" = {
          xkb_layout = "us,is";
        };

        "1390:306:ELECOM_TrackBall_Mouse_DEFT_Pro_TrackBall" = {
          scroll_method = "on_button_down";
          scroll_button = "279";
        };
      };

      ######################
      ## STARTUP PROGRAMS ##
      ######################
      startup = [
        {
          command = ''
            ${pkgs.swayidle}/bin/swayidle -w \
              timeout 300 '${lockCommand}' \
              timeout 600 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
              resume '${pkgs.sway}/bin/swaymsg "output * dpms on"' \
              before-sleep '${lockCommand}'
          '';
        }
      ];

      bars = [];
    };

    extraConfig = ''
      for_window [class="steam_app_.*"] inhibit_idle fullscreen
      bar {
        swaybar_command waybar
      }
    '';

    wrapperFeatures = { gtk = true; };
  };
  
}
