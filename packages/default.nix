{pkgs, ...}: let
  callPackage = pkgs.lib.callPackageWith pkgs;

  lib = pkgs.lib;

  self = {
    anytype = callPackage ./anytype {};
    morgen = callPackage ./morgen {};
    plex-exporter = callPackage ./plex-exporter {};
    kbct = callPackage ./kbct {};
    whitesur-gtk-theme = callPackage ./whitesur-gtk-theme {};
    whitesur-icon-theme = callPackage ./whitesur-icon-theme {};
    whitesur-kde = callPackage ./whitesur-kde {};

    tmuxPlugins = lib.recurseIntoAttrs (callPackage ./tmux-plugins {});
  };
in
  self
