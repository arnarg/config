{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.tmux;
in with pkgs.stdenv; with lib; {
  options.local.development.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {

    home-manager.users.arnar = {
      programs.tmux.enable = true;

      # Recommended by tmux-tilish
      programs.tmux.baseIndex = 1;
      programs.tmux.escapeTime = 0;

      programs.tmux.plugins = with pkgs; [
        pkgs.tmuxPlugins.sensible
        pkgs.tmuxPlugins.fingers
        {
          plugin = mypkgs.tmuxPlugins.tilish;
          extraConfig = ''
            set -g @tilish-navigate 'on'
            set -g @tilish-default 'main-vertical'
          '';
        }
        mypkgs.tmuxPlugins.navigate
        mypkgs.tmuxPlugins.jump
      ];

      programs.tmux.extraConfig = ''
        # Set status bar on top
        set-option -g status-position top
        # Enable vi copy mode
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
      '';
    };
  
  };
}
