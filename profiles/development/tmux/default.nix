{ config, lib, pkgs, mypkgs, ... }:
let
  cfg = config.local.development.tmux;
  desktopEnabled = config.local.desktop.enable;
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
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.tilish;
          extraConfig = ''
            set -g @tilish-navigate 'on'
            set -g @tilish-default 'main-vertical'
          '';
        }
        mypkgs.tmuxPlugins.navigate
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
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel${optionalString desktopEnabled "\\; run \"${pkgs.tmux}/bin/tmux save-buffer - | ${pkgs.wl-clipboard}/bin/wl-copy -np > /dev/null\""}
        bind-key -T copy-mode-vi 'Y' send -X copy-selection-and-cancel${optionalString desktopEnabled "\\; run \"${pkgs.tmux}/bin/tmux save-buffer - | ${pkgs.wl-clipboard}/bin/wl-copy -n > /dev/null\""}
      '';
    };
  
  };
}
