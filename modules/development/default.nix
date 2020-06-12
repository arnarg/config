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
    ./zsh
  ];

  config = mkIf cfg.enable {
    local.development.git.enable = true;
    local.development.gpg.enable = true;
    local.development.kr.enable = true;
    local.development.neovim.enable = true;
    local.development.podman.enable = true;
    local.development.tmux.enable = true;
    local.development.zsh.enable = true;

    # For yubikey
    services.pcscd.enable = if isLinux then true else false;

    home-manager.users.arnar.home.packages = import ./packages.nix { inherit pkgs; };
  };
}
