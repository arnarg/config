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
  };

  config = mkIf cfg.enable {
    
    home-manager.users.arnar = {
      programs.git.enable = true;
      programs.git.userName = cfg.userName;
      programs.git.userEmail = cfg.userEmail;
    };

  };
}
