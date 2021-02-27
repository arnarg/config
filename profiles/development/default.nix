{ config, lib, pkgs, ... }:
{
  imports = [
    ./aerc
    ./git
    ./gpg
    ./homehosts
    ./libvirt
    ./neovim
    ./pass
    ./podman
    ./tmux
    ./yubikey
    ./zsh
  ];

  config = with lib; {
    # Default packages for this profile
    local.development.aerc.enable = mkDefault true;
    local.development.git.enable = mkDefault true;
    local.development.gpg.enable = mkDefault true;
    local.development.neovim.enable = mkDefault true;
    local.development.podman.enable = mkDefault true;
    local.development.tmux.enable = mkDefault true;
    local.development.yubikey.enable = mkDefault true;
    local.development.zsh.enable = mkDefault true;
  };
}
