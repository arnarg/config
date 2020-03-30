{ lib, config, ... }:
with lib;

{
  options.local.displayScalingFactor = mkOption {
    type = types.float;
    default = 1;
    description = "A floating point number that is used to scale font sizes.";
  };

  config = {
    lib = {

      # displayScaling is used to scale UI elements depending on scaling factor set by config.local.displayScalingFactor.
      # It takes in an integer and offers both flooring and ceiling functions for rounding.
      displayScaling = rec {
        _byFunc = f: n:
          let
            factor = config.local.displayScalingFactor;
          in
          assert assertMsg (builtins.typeOf n == "int") "displayScaling: Expected an integer, got ${builtins.typeOf n}";
          if factor == 1 then n
          else if factor > 1 then _byFunc' f n (n*factor)
          else warn "displayScaling: Scaling factor should not be less than 1, returning n." n;

        _byFunc' = f: n: target:
          if (f n) > target then n
          else _byFunc' f (n+1) target;

        floor = n: _byFunc (n: n+1) n;
        ceil = n: _byFunc (n: n) n;
      };

    };
  };
}
