{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    okta-aws = callPackage ./okta-aws { };
  };
in self
