{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.profiles.development.radicle;
in {
  options.profiles.development.radicle = with lib; {
    enable = mkEnableOption "radicle";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.radicle.packages.${pkgs.system}.default
    ];
  };
}
