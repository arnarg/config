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
        {
          plugin = mypkgs.tmux-plugins.tmux-tilish;
          extraConfig = ''
            set -g @tilish-navigate 'on'
          '';
        }
        mypkgs.tmux-plugins.tmux-navigate
      ];
    };
  
  };
}
