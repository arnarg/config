{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith pkgs;

  self = {
    bemenu = callPackage ./bemenu { };
    desktop-scripts = callPackage ./desktop-scripts { };
    hddled = callPackage ./hddled { kernel = pkgs.linuxPackages.kernel; };
    kr = callPackage ./kr { };
    ksniff = callPackage ./ksniff { };
    mkosi = callPackage ./mkosi { };
    nsh = callPackage ./nsh { };
    plex-exporter = callPackage ./plex-exporter { };
    squeekboard = callPackage ./squeekboard { };
    sway-accel-rotate = callPackage ./sway-accel-rotate { };
    waybind = callPackage ./waybind { };
    yubikey-agent = callPackage ./yubikey-agent { };
  };
in self
