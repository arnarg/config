{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.pass;
  gopass = pkgs.gopass.override { passAlias = true; };
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
      programs.password-store.package = gopass;
      programs.password-store.settings = {
        PASSWORD_STORE_KEY = cfg.gpgKey;
      };
    };

  };
}
