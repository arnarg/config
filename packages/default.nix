{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith pkgs;

  self = {
    bemenu = callPackage ./bemenu { };
    desktop-scripts = callPackage ./desktop-scripts { };
    hddled = callPackage ./hddled { kernel = pkgs.linuxPackages.kernel; };
    ksniff = callPackage ./ksniff { };
    libnss_homehosts = callPackage ./libnss_homehosts { };
    mkosi = callPackage ./mkosi { };
    nsh = callPackage ./nsh { };
    plex-exporter = callPackage ./plex-exporter { };
    pushnix = callPackage ./pushnix { };
    sshuttle = callPackage ./sshuttle { };
    sway-accel-rotate = callPackage ./sway-accel-rotate { };
    waybind = callPackage ./waybind { };
    yubikey-agent = callPackage ./yubikey-agent { };

    morph = callPackage "${fetchTarball https://github.com/DBCDK/morph/archive/v1.5.0.tar.gz}/nix-packaging" { version = "1.5.0"; };

    # Override packages used in my nixos config
    # I add this here because my CI script builds all packages in this file and caches them in cachix
    spotifyd = pkgs.spotifyd.override { withMpris = true; };
    waybar = pkgs.waybar.override { pulseSupport = true; };
  };
in self
