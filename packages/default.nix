{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith pkgs;

  lib = pkgs.lib;

  self = {
    desktop-scripts = callPackage ./desktop-scripts { };
    plex-exporter = callPackage ./plex-exporter { };
    sway-accel-rotate = callPackage ./sway-accel-rotate { };
    waybind = callPackage ./waybind { };
    kbct = callPackage ./kbct { };
    tela-icon-theme = callPackage ./tela-icon-theme { };
    material-shell = callPackage ./material-shell { };

    tmuxPlugins = lib.recurseIntoAttrs (callPackage ./tmux-plugins {});

    # Override packages used in my nixos config
    # I add this here because my CI script builds all packages in this file and caches them in cachix
    spotifyd = pkgs.spotifyd.override { withMpris = true; withPulseAudio = true; };
    waybar = pkgs.waybar.override { pulseSupport = true; };
  };
in self
