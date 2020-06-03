{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.git;
  userName = config.local.userName;
in with lib; {
  options.local.development.git = {
    enable = mkEnableOption "git";
    userName = mkOption {
      type = types.str;
      default = "Arnar Gauti Ingason";
      description = "Username for Git";
    };
    userEmail = mkOption {
      type = types.str;
      default = "arnarg@fastmail.com";
      description = "User email for Git";
    };
    gpgKey = mkOption {
      type = types.str;
      default = null;
      description = "GPG key to use for signing";
    };
  };

  config = mkIf cfg.enable {
    
    home-manager.users.arnar = {
      programs.git.enable = true;
      programs.git.userName = cfg.userName;
      programs.git.userEmail = cfg.userEmail;

      programs.git.signing.key = cfg.gpgKey;
      programs.git.signing.signByDefault = builtins.isString cfg.gpgKey;
    };

  };
}
