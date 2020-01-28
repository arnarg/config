{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    bemenu = callPackage ./bemenu { };
    okta-aws = callPackage ./okta-aws { };
    operator-sdk = callPackage ./operator-sdk { };
    kr = callPackage ./kr { };
  };
in self
