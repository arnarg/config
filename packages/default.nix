{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    bemenu = callPackage ./bemenu { };
    desktop-scripts = callPackage ./desktop-scripts { };
    hddled = callPackage ./hddled { kernel = pkgs.linuxPackages.kernel; };
    kr = callPackage ./kr { };
    ksniff = callPackage ./ksniff { };
    okta-aws = callPackage ./okta-aws { };
    operator-sdk = callPackage ./operator-sdk { };
    plex-exporter = callPackage ./plex-exporter { };
    squeekboard = callPackage ./squeekboard { };
    sway-accel-rotate = callPackage ./sway-accel-rotate { };
    tmux-plugins = callPackage ./tmux-plugins { };
    waybind = callPackage ./waybind { };
    yubikey-agent = callPackage ./yubikey-agent { };
    pmake = callPackage ./pmake { };
  };
in self
