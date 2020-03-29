{ lib, isHiDPI, isLaptop, extraConfig }:
let
  laptopConfig = {
    # No memory module because space is premium :(
    modules-right = [
      "network"
      "pulseaudio"
      "battery"
      "clock"
    ];
    battery = {
      bat = "BAT1";
      states = {
        warning = 30;
        critical = 15;
      };
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      format = "{icon} {capacity}%";
    };
    pulseaudio = {
      format = " {volume}%";
      format-muted = "";
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
    format-wifi = " {essid} ({signalStrength}%)";
    format-ethernet = " {ipaddr}/{cidr}";
    format-disconnected = " Disconnected";
  };
  memory = {
    format = " {percentage}%";
  };
  clock = {
    format-alt = " {:%a, %d. %b %H:%M}";
    format = " {:%H:%M}";
  };
} // (lib.optionalAttrs isLaptop laptopConfig) // extraConfig
