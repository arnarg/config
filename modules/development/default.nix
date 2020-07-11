{ config, lib, pkgs, ... }:
let
  cfg = config.local.development;
in with pkgs.stdenv; with lib; {
  options.local.development = {
    enable = mkEnableOption "development";
  };

  imports = [
    ./docker
    ./git
    ./gpg
    ./kr
    ./libvirt
    ./neovim
    ./pass
    ./podman
    ./tmux
    ./yubikey
    ./zsh
  ];

  config = mkIf cfg.enable {
    local.development.git.enable = mkDefault true;
    local.development.gpg.enable = mkDefault true;
    local.development.kr.enable = mkDefault false;
    local.development.neovim.enable = mkDefault true;
    local.development.podman.enable = mkDefault true;
    local.development.tmux.enable = mkDefault false;
    local.development.yubikey.enable = mkDefault true;
    local.development.zsh.enable = mkDefault true;

    home-manager.users.arnar.home.packages = import ./packages.nix { inherit pkgs; };
  };
}
