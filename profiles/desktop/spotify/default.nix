{ config, lib, pkgs, mypkgs, ... }:
let
  cfg = config.local.desktop.spotify;
in with lib; {
  options.local.desktop.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {

    home-manager.users.arnar = {
      home.packages = with pkgs; [
        mypkgs.spotifyd
        spotify-tui
      ];
      wayland.windowManager.sway.config.keybindings = {
        XF86AudioPlay = "exec ${pkgs.playerctl}/bin/playerctl --all-players play-pause";
        XF86AudioNext = "exec ${pkgs.playerctl}/bin/playerctl --all-players next";
        XF86AudioPrev = "exec ${pkgs.playerctl}/bin/playerctl --all-players previous";
      };
    };

  };
}
