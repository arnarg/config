{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.libvirt;
in with lib; {
  options.local.development.libvirt = {
    enable = mkEnableOption "libvirt";
  };

  config = mkIf cfg.enable {

    virtualisation.libvirtd.enable = true;

    users.users.arnar.extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; [ virt-manager vagrant ];

  };
}
