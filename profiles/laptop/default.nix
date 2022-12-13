{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./kbct
  ];

  config = {
    # Enable UPower to watch battery stats
    services.upower.enable = true;

    # Enable networkmanager
    networking.networkmanager.enable = true;
    users.users.arnar.extraGroups = ["networkmanager"];
    services.resolved.enable = true;

    # Enable tlp
    services.tlp.enable = true;

    # Enable thermald
    services.thermald.enable = true;

    # Automatically suspend-then-hibernate when lid is closed
    services.logind.lidSwitch = "suspend-then-hibernate";
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=1h
    '';

    # Enable light to control backlight
    programs.light.enable = true;

    # Enable kbct key rebinder
    local.laptop.kbct.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;

    # Files to persist on laptops with immutable profile turned on
    environment.persistence."${config.local.immutable.persistPath}" = {
      hideMounts = true;
      directories = [
        "/var/lib/bluetooth"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/var/lib/NetworkManager/secret_key"
        "/var/lib/NetworkManager/seen-bssids"
        "/var/lib/NetworkManager/timestamps"
      ];
    };
  };
}
