{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.development;
in {
  options.profiles.development.tmux = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable tmux setup";
    };
    copyCommand = mkOption {
      type = types.str;
      default = "${pkgs.wl-clipboard}/bin/wl-copy";
      description = "Command to pipe to when yanking";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.tmux.enable) {
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
      bind -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel '${cfg.tmux.copyCommand}'
      # Set tmux-256color
      set -g default-terminal "tmux-256color"
      set -g terminal-overrides ",xterm-256color:RGB"
      # Automatically set window title to working directory
      setw -g automatic-rename-format "#{b:pane_current_path}"
    '';
  };
}
