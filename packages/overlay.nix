final: prev: {
  anytype = prev.callPackage ./anytype {};
  kbct = prev.callPackage ./kbct {};
  plex-exporter = prev.callPackage ./plex-exporter {};
  whitesur-gtk-theme = prev.callPackage ./whitesur-gtk-theme {};
  whitesur-icon-theme = prev.callPackage ./whitesur-icon-theme {};
  whitesur-firefox-theme = prev.callPackage ./whitesur-firefox-theme {};

  myTmuxPlugins = prev.lib.recurseIntoAttrs (prev.callPackage ./tmux-plugins {});
}
