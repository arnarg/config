final: prev: {
  desktop-scripts = prev.callPackage ./desktop-scripts {};
  kbct = prev.callPackage ./kbct {};
  morgen = prev.callPackage ./morgen {};
  plex-exporter = prev.callPackage ./plex-exporter {};
  sway-accel-rotate = prev.callPackage ./sway-accel-rotate {};
  waybind = prev.callPackage ./waybind {};
  whitesur-gtk-theme = prev.callPackage ./whitesur-gtk-theme {};

  myTmuxPlugins = prev.lib.recurseIntoAttrs (prev.callPackage ./tmux-plugins {});

  spotifyd = prev.spotifyd.override { withMpris = true; withPulseAudio = true; };
  waybar = prev.waybar.override { pulseSupport = true; };
}