{ lib, isHiDPI, isLaptop, extraConfig }:
let
  laptopConfig = {
    modules-right = [
      "network"
      "memory"
      "battery"
      "clock"
    ];
    battery = {
      bat = "BAT1";
    };
  };
in {
  layer = "top";
  height = if isHiDPI then 40 else 30;
  modules-left = [ "sway/workspaces" "sway/mode" ];
  modules-center = [ "sway/window" ];
  modules-right = [
    "network"
    "memory"
    "clock"
  ];
  "sway/window" = {
    max-length = 50;
  };
  network = {
    format-wifi = "{essid} ({signalStrength}%)";
    format-ethernet = "{ipaddr}/{cidr}";
    format-disconnected = "Disconnected";
  };
  clock = {
    format-alt = "{:%a, %d. %b %H:%M}";
  };
} // (lib.optionalAttrs isLaptop laptopConfig) // extraConfig
