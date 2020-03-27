{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    libinput-gestures
  ];

  users.users.arnar.extraGroups = [ "networkmanager" ];

  networking.networkmanager.enable = true;

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    TLP_DEFAULT_MODE=BAT
    CPU_SCALING_GOVERNOR_ON_AC=performance
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
  '';

  programs.light.enable = true;

  services.upower.enable = true;

  local.desktop.isLaptop = true;
  local.desktop.isHiDPI = lib.mkDefault false;
}
