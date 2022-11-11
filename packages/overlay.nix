final: prev: {
  anytype = prev.callPackage ./anytype {};
  kbct = prev.callPackage ./kbct {};
  morgen = prev.callPackage ./morgen {};
  plex-exporter = prev.callPackage ./plex-exporter {};
  tpm-fido = prev.callPackage ./tpm-fido {};
  w4-bin = callPackage ./w4-bin {};
  whitesur-gtk-theme = prev.callPackage ./whitesur-gtk-theme {};
  whitesur-icon-theme = prev.callPackage ./whitesur-icon-theme {};

  myTmuxPlugins = prev.lib.recurseIntoAttrs (prev.callPackage ./tmux-plugins {});
}
