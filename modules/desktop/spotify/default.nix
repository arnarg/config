{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.spotify;
  swayEnabled = config.local.desktop.sway.enable;
in with lib; {
  options.local.desktop.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      (spotifyd.override { withMpris = true; })
      spotify-tui
      playerctl
    ];

    home-manager.users.arnar.wayland.windowManager.sway.config.keybindings = mkIf swayEnabled {
      XF86AudioPlay = "exec ${pkgs.playerctl}/bin/playerctl --all-players play-pause";
      XF86AudioNext = "exec ${pkgs.playerctl}/bin/playerctl --all-players next";
      XF86AudioPrev = "exec ${pkgs.playerctl}/bin/playerctl --all-players previous";
    };

  };
}
