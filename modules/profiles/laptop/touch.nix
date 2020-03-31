{ config, pkgs, lib, ... }:
let
  cfg = config.local.laptop.touch;
in with lib; {
  options.local.laptop.touch = {
    enable = mkEnableOption "touch";
  };

  config = mkIf cfg.enable {

    # Enables d-bus activation of squeekboard
    home-manager.users.arnar.xdg.dataFile."dbus-1/services/sm.puri.OSK0.service" = {
      text = ''
        [D-BUS Service]
        Name=sm.puri.OSK0
        Exec=${pkgs.mypkgs.squeekboard}/bin/squeekboard
        User=arnar
      '';
    };

    # Add button to waybar to toggle squeekboard
    local.desktop.sway.waybar.config = {
      "custom/squeekboard" = {
        format = "";
        on-click = "${pkgs.mypkgs.desktop-scripts}/waybar/squeekboard.sh";
      };
      modules-right = lib.mkAfter [ "custom/squeekboard" ];
    };

    # Workaround for squeekboard so it doesn't mess up key layouts for other keyboards in sway
    # https://github.com/swaywm/sway/issues/5134
    local.desktop.sway.extraConfig = lib.mkAfter ''
      # Workaround for squeekboard
      seat seat0 keyboard_grouping none
    '';

  };
}
