final: prev: {
  anytype = prev.callPackage ./anytype {};
  morgen = prev.callPackage ./morgen {};
  plex-exporter = prev.callPackage ./plex-exporter {};
  tpm-fido = prev.callPackage ./tpm-fido {};
  w4-bin = prev.callPackage ./w4-bin {};

  myTmuxPlugins = prev.lib.recurseIntoAttrs (prev.callPackage ./tmux-plugins {});
}
