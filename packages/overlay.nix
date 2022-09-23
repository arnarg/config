final: prev: {
  anytype = prev.callPackage ./anytype {};
  morgen = prev.callPackage ./morgen {};
  kbct = prev.callPackage ./kbct {};
  plex-exporter = prev.callPackage ./plex-exporter {};
  whitesur-gtk-theme = prev.callPackage ./whitesur-gtk-theme {};
  whitesur-icon-theme = prev.callPackage ./whitesur-icon-theme {};
  whitesur-kde = prev.callPackage ./whitesur-kde {};

  myTmuxPlugins = prev.lib.recurseIntoAttrs (prev.callPackage ./tmux-plugins {});
}
