{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith pkgs;

  lib = pkgs.lib;

  self = {
    anytype = callPackage ./anytype { };
    plex-exporter = callPackage ./plex-exporter { };
    kbct = callPackage ./kbct { };
    tela-icon-theme = callPackage ./tela-icon-theme { };
    whitesur-gtk-theme = callPackage ./whitesur-gtk-theme { };
    whitesur-icon-theme = callPackage ./whitesur-icon-theme { };
    whitesur-firefox-theme = callPackage ./whitesur-firefox-theme { };

    tmuxPlugins = lib.recurseIntoAttrs (callPackage ./tmux-plugins {});
  };
in self
