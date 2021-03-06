{ config, lib, pkgs, ... }:
{
  imports = [
    ./waybind
    ./kbct
  ];

  options.local.laptop.enable = lib.mkEnableOption "laptop";

  config = {
    local.laptop.enable = true;

    # Enable UPower to watch battery stats
    services.upower.enable = true;

    # Enable networkmanager
    networking.networkmanager.enable = true;
    users.users.arnar.extraGroups = [ "networkmanager" ];
    environment.systemPackages = with pkgs; [ networkmanager-openvpn ];
  
    # Enable tlp
    #services.tlp.enable = true;
    #services.tlp.settings = {
    #  TLP_DEFAULT_MODE = "BAT";
    #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #  CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";
    #};
  
    # Enable light to control backlight
    programs.light.enable = true;

    # Enable waybind key rebinder
    local.laptop.waybind.enable = false;
    local.laptop.kbct.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
  
    # Files to persist on laptops with immutable profile turned on
    local.immutable.links.etc = [
      "/etc/NetworkManager/system-connections"
    ];
    local.immutable.links.tmpfiles = [
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/NetworkManager/seen-bssids"
      "/var/lib/NetworkManager/timestamps"
      "/var/lib/bluetooth"
    ];
  };
}
