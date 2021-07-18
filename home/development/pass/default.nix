{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.pass;
in with lib; {
  options.local.development.pass = {
    gpgKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "GPG key to use for signing";
    };
  };

  config = mkIf (isString cfg.gpgKey) {

    programs.password-store.enable = true;
    programs.password-store.package = pkgs.gopass;
    programs.password-store.settings = mkIf (isString cfg.gpgKey) {
      PASSWORD_STORE_KEY = cfg.gpgKey;
    };

  };
}
