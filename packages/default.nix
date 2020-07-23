{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith pkgs;

  self = {
    bemenu = callPackage ./bemenu { };
    desktop-scripts = callPackage ./desktop-scripts { };
    hddled = callPackage ./hddled { kernel = pkgs.linuxPackages.kernel; };
    kr = callPackage ./kr { };
    ksniff = callPackage ./ksniff { };
    libnss_homehosts = callPackage ./libnss_homehosts { };
    mkosi = callPackage ./mkosi { };
    nsh = callPackage ./nsh { };
    plex-exporter = callPackage ./plex-exporter { };
    squeekboard = callPackage ./squeekboard { };
    sway-accel-rotate = callPackage ./sway-accel-rotate { };
    waybind = callPackage ./waybind { };
    yubikey-agent = callPackage ./yubikey-agent { };

    morph = callPackage "${fetchTarball https://github.com/DBCDK/morph/archive/v1.5.0.tar.gz}/nix-packaging" { };
  };
in self
