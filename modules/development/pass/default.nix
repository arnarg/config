{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.pass;
in with lib; {
  options.local.development.pass = {
    enable = mkEnableOption "pass";
    gpgKey = mkOption {
      type = types.str;
      default = null;
      description = "GPG key to use for signing";
    };
  };

  config = mkIf cfg.enable {

    home-manager.users.arnar = {
      programs.password-store.enable = true;
      programs.password-store.settings = {
        PASSWORD_STORE_KEY = cfg.gpgKey;
        PASSWORD_STORE_DIR = "$XDG_DATA_HOME/pass";
      };
    };

  };
}
