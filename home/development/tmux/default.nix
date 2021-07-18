{ config, lib, pkgs, ... }:
{
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
        '';
      }
      myTmuxPlugins.navigate
      tmuxPlugins.jump
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];

    programs.tmux.extraConfig = ''
      # Set status bar on top
      set-option -g status-position top
      # Enable vi copy mode
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
    '';

  };
}
