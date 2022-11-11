{pkgs, ...}: let
  callPackage = pkgs.lib.callPackageWith pkgs;

  lib = pkgs.lib;

  self = {
    anytype = callPackage ./anytype {};
    kbct = callPackage ./kbct {};
    morgen = callPackage ./morgen {};
    plex-exporter = callPackage ./plex-exporter {};
    tpm-fido = callPackage ./tpm-fido {};
    w4-bin = callPackage ./w4-bin {};
    whitesur-gtk-theme = callPackage ./whitesur-gtk-theme {};
    whitesur-icon-theme = callPackage ./whitesur-icon-theme {};

    tmuxPlugins = lib.recurseIntoAttrs (callPackage ./tmux-plugins {});
  };
in
  self
