{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    bemenu = callPackage ./bemenu { };
    hddled = callPackage ./hddled { kernel = pkgs.linuxPackages.kernel; };
    kr = callPackage ./kr { };
    okta-aws = callPackage ./okta-aws { };
    operator-sdk = callPackage ./operator-sdk { };
  };
in self
