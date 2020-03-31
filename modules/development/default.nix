{ config, lib, pkgs, ... }:
let
  cfg = config.local.development;
  userName = config.local.userName;
in with pkgs.stdenv; with lib; {
  options.local.development = {
    enable = mkEnableOption "development";
  };

  imports = [
    ./docker
    ./git
    ./kr
    ./neovim
    ./zsh
  ];

  config = mkIf cfg.enable {
    local.development.git.enable = true;
    local.development.kr.enable = true;
    local.development.neovim.enable = true;
    local.development.zsh.enable = true;

    # For yubikey
    services.pcscd.enable = if isLinux then true else false;

    home-manager.users.${userName}.home.packages = import ./packages.nix { inherit pkgs; };
  };
}