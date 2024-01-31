{...}: {
  # Rename the interfaces based on the MAC addresses
  # that are set by u-boot.
  systemd.network.links = {
    "10-wan" = {
      matchConfig.MACAddress = "68:27:19:a5:79:51";
      linkConfig.Name = "wan0";
    };
    "10-lan" = {
      matchConfig.MACAddress = "68:27:19:a5:79:52";
      linkConfig.Name = "lan0";
    };
  };

  # The device has 2 leds to correspond to the 2
  # ethernet interfaces.
  # The device tree defines these leds as 'green:wan'
  # and 'green:lan'.
  # Here we load the 'ledtrig-netdev' module and setup
  # the leds to trigger on events on those interfaces.
  boot.kernelModules = ["ledtrig-netdev"];
  systemd.services.eth-ledsetup = {
    script = ''
      # Wan interface led setup
      echo "netdev" > /sys/class/leds/green\:wan/trigger
      echo "wan0"   > /sys/class/leds/green\:wan/device_name
      echo "1"      > /sys/class/leds/green\:wan/rx
      echo "1"      > /sys/class/leds/green\:wan/tx
      # Lan interface led setup
      echo "netdev" > /sys/class/leds/green\:lan/trigger
      echo "lan0"   > /sys/class/leds/green\:lan/device_name
      echo "1"      > /sys/class/leds/green\:lan/rx
      echo "1"      > /sys/class/leds/green\:lan/tx
    '';

    wantedBy = ["multi-user.target"];
    serviceConfig.type = "oneshot";
  };
}
