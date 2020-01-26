{ config, lib, pkgs, ... }:
let
  cfg = config.local.home;
in with pkgs.stdenv; with lib; {
  options.local.home = {
    git.userName = mkOption {
      type = types.str;
      default = "Arnar Gauti Ingason";
      description = "Username for Git";
    };

    git.userEmail = mkOption {
      type = types.str;
      default = "arnarg@fastmail.com";
      description = "User e-mail for Git";
    };
  };

  imports = [
    ./zsh.nix
    ./neovim.nix
  ];

  config = {
    time.timeZone = "Iceland";
    nix.trustedUsers = [ "root" "arnar" ];

    environment.systemPackages = [ pkgs.zsh ];
    users.users.arnar.shell = pkgs.zsh;
    users.users.arnar.home = "/home/arnar";

    home-manager.users.arnar = {
      home.packages = import ./packages.nix { inherit pkgs; };

      #########
      ## GIT ##
      #########
      programs.git.enable = true;
      programs.git.userName = cfg.git.userName;
      programs.git.userEmail = cfg.git.userEmail;

      #########
      ## FZF ##
      #########
      programs.fzf.enable = true;
      programs.fzf.enableZshIntegration = true;

      #############
      ## FIREFOX ##
      #############
      programs.firefox.enable = true;
    };
  };
}
