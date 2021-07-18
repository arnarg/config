{ config, lib, pkgs, ... }:
{
  imports = [
    ./android
    ./libvirt
    ./podman
    ./yubikey
    ./zsh
  ];

  config = with lib; {
    # Default packages for this profile
    local.development.podman.enable = mkDefault true;
    local.development.yubikey.enable = mkDefault true;
    local.development.zsh.enable = mkDefault true;
  };
}
