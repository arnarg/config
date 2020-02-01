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

    userName = mkOption {
      type = types.str;
      default = "arnar";
      description = "The user name";
    };

    enableFirefox = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to enable firefox or not";
    };
  };

  imports = [
    ./zsh.nix
    ./neovim.nix
    ./kr.nix
  ];

  config = {
    time.timeZone =
      if isDarwin then null
      else "Iceland";
    nix.trustedUsers = [ "root" cfg.userName ];

    environment.systemPackages = [ pkgs.zsh ];
    users.users.${cfg.userName} = {
      name = cfg.userName;
      shell = pkgs.zsh;
      home = 
        if isDarwin then "/Users/${cfg.userName}"
        else "/home/${cfg.userName}";
    };

    home-manager.users.${cfg.userName} = {
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
      programs.firefox.enable = cfg.enableFirefox;
    };
  };
}
