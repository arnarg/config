{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.zsh;
in with pkgs.stdenv; with lib; {
  options.local.development.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {

    programs.zsh.enable = true;
    programs.zsh.syntaxHighlighting.enable = true;
    users.users.arnar.shell = pkgs.zsh;

  };
}
