{
  config,
  lib,
  pkgs,
  ...
}: {
  ##############
  ## RENAMING ##
  ##############
  # Neither of the interfaces in my NanoPI R4S
  # have a stable MAC address.
  # To differentiate them I need to set some unique matcher.
  # The wan interface uses the "st_gmac" driver according
  # to ethtool but setting `matchConfig.Driver` to `st_gmac`
  # didn't work so matching on `OriginalName` as `eth0` is
  # necessary.
  # This is stable anyway since with the lan interface I match
  # on the driver which is `r8169` and that _does_ work on that
  # interface.
  # After matching those I set a custom name and a stable MAC
  # address on both interfaces.
  systemd.network.links."10-wan" = {
    matchConfig.OriginalName = "eth0";
    linkConfig.Name = "wan0";
    linkConfig.MACAddress = "ea:22:a9:ef:37:66";
  };
  systemd.network.links."10-lan" = {
    matchConfig.Driver = "r8169";
    linkConfig.Name = "lan0";
    linkConfig.MACAddress = "6e:90:70:03:2f:f6";
  };

  ##############
  ## WAN SIDE ##
  ##############
  networking.interfaces.wan0 = {
    useDHCP = true;
  };

  ##############
  ## LAN SIDE ##
  ##############
  networking.interfaces.lan0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "10.10.10.1";
        prefixLength = 24;
      }
    ];
  };

  ##################
  ## LED HANDLING ##
  ##################
  # The device has 2 leds to correspond to the 2
  # ethernet interfaces.
  # The device tree defines these leds as 'green:wan'
  # and 'green:lan'.
  # Here we load the 'ledtrig-netdev' module and setup
  # the leds to trigger on events on those interfaces.
  boot.kernelModules = ["ledtrig-netdev"];
  systemd.services.ledsetup = {
    script = ''
      # Wan interface led setup
      echo "netdev" > /sys/class/leds/green\:wan/trigger
      echo "wan0"   > /sys/class/leds/green\:wan/device_name
      echo "1"      > /sys/class/leds/green\:wan/link
      echo "1"      > /sys/class/leds/green\:wan/rx
      echo "1"      > /sys/class/leds/green\:wan/tx

      # Lan interface led setup
      echo "netdev" > /sys/class/leds/green\:lan/trigger
      echo "lan0" > /sys/class/leds/green\:lan/device_name
      echo "1"      > /sys/class/leds/green\:lan/link
      echo "1"      > /sys/class/leds/green\:lan/rx
      echo "1"      > /sys/class/leds/green\:lan/tx
    '';

    wantedBy = ["multi-user.target"];
    serviceConfig.type = "oneshot";
  };
}
