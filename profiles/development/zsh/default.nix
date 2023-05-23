{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.development.zsh;
in
  with pkgs.stdenv;
  with lib; {
    options.local.development.zsh = {
      enable = mkEnableOption "zsh";
    };

    config = mkIf cfg.enable {
      users.users.arnar.shell = pkgs.zsh;

      programs.zsh.enable = true;
    };
  }
