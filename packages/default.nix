{pkgs, ...}: let
  callPackage = pkgs.lib.callPackageWith pkgs;

  lib = pkgs.lib;

  self = {
    anytype = callPackage ./anytype {};
    ente-desktop = callPackage ./ente-desktop {};
    morgen = callPackage ./morgen {};
    plex-exporter = callPackage ./plex-exporter {};
    tpm-fido = callPackage ./tpm-fido {};
    w4-bin = callPackage ./w4-bin {};

    tmuxPlugins = lib.recurseIntoAttrs (callPackage ./tmux-plugins {});
  };
in
  self
