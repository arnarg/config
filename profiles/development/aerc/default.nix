{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.aerc;
in with lib; {
  options.local.development.aerc = {
    enable = mkEnableOption "aerc";
  };

  config = mkIf cfg.enable {
    home-manager.users.arnar = {
      home.packages = with pkgs; [ aerc ];

      xdg.configFile."aerc/aerc.conf" = {
        text = ''
          [ui]
          timestamp-format=2006-01-02 15:04

          [filters]
          subject,~^\[PATCH=awk -f ${pkgs.aerc}/share/aerc/filters/hldiff
          text/html=${pkgs.aerc}/share/aerc/filters/html
          text/*=${pkgs.gawk}/bin/awk -f ${pkgs.aerc}/share/aerc/filters/plaintext
          image/*=${pkgs.catimg}/bin/catimg -w $(${pkgs.ncurses}/bin/tput cols) -

          [triggers]
          new-email=exec ${pkgs.libnotify}/bin/notify-send "New email from %n" "%s"

          [templates]
          template-dirs=${pkgs.aerc}/share/aerc/templates/
        '';
      };
    };
  };
}
