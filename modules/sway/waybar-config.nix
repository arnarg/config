{ pkgs, lib, isHiDPI, isLaptop, extraConfig }:
let
  laptopConfig = {
    # No memory module because space is premium :(
    modules-right = [
      "custom/lang"
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
    "custom/lang"
    "network"
    "memory"
    "clock"
  ];
  "sway/window" = {
    max-length = 50;
  };
  network = {
    format-wifi = " {signalStrength}%";
    format-ethernet = " {ipaddr}/{cidr}";
    format-disconnected = " Disconnected";
    tooltip-format-wifi = "{essid}";
    tooltip-format-ethernet = "{ipaddr}/{cidr}";
    tooltip-format-disconnected = "Disconnected";
  };
  memory = {
    format = " {percentage}%";
  };
  clock = {
    format-alt = " {:%a, %d. %b %H:%M}";
    format = " {:%H:%M}";
    tooltip = false;
  };
  "custom/lang" = {
    format = " {}";
    exec = "${pkgs.mypkgs.desktop-scripts}/waybar/lang.sh";
    on-click = "${pkgs.mypkgs.desktop-scripts}/waybar/lang.sh switch 1";
    interval = "once";
    signal = 1;
    return-type = "json";
  };
} // (lib.optionalAttrs isLaptop laptopConfig) // extraConfig
