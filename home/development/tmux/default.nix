{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.tmux;
in
  with lib; {
    options.local.tmux = {
      copyCommand = mkOption {
        type = types.str;
        default = "${pkgs.wl-clipboard}/bin/wl-copy";
        description = "Command to pipe to when yanking";
      };
    };
    config = {
      programs.tmux.enable = true;

      # Recommended by tmux-tilish
      programs.tmux.baseIndex = 1;
      programs.tmux.escapeTime = 0;

      programs.tmux.plugins = with pkgs; [
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.tilish;
          extraConfig = ''
            set -g @tilish-navigate 'on'
            set -g @tilish-default 'main-vertical'
            # Automatically resize left pane to 70% width
            bind -n "M-w" resize-pane -t 1 -x 70%
          '';
        }
        myTmuxPlugins.navigate
        tmuxPlugins.jump
        tmuxPlugins.gruvbox
      ];

      programs.tmux.extraConfig = ''
        # Set status bar on top
        set-option -g status-position top
        # Enable vi copy mode
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel '${cfg.copyCommand}'
      '';
    };
  }
