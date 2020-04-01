{ config, lib, pkgs, ... }:
let
  cfg = config.local;
  mkEmptyAttrsOption = lib.mkOption { type = lib.types.attrs; default = {}; };
in with lib; {
  # Declaring dummy options not available in nix-darwin
  options = {
    virtualisation = mkEmptyAttrsOption;
    hardware = mkEmptyAttrsOption;
    sound = mkEmptyAttrsOption;
    lib = mkEmptyAttrsOption;
    programs = {
      sway = mkEmptyAttrsOption;
      light = mkEmptyAttrsOption;
    };
    services = {
      tlp = mkEmptyAttrsOption;
      pcscd = mkEmptyAttrsOption;
    };
    security.sudo = mkEmptyAttrsOption;
    networking.networkmanager = mkEmptyAttrsOption;
    fonts.enableDefaultFonts = mkEmptyAttrsOption;
  };

  config = {
    # Run krd
    launchd.user.agents.krd = mkIf cfg.development.kr.enable {
      serviceConfig.ProgramArguments = [ "${pkgs.mypkgs.kr}/bin/krd" ];
      serviceConfig.Label = "co.krypt.krd";
      serviceConfig.RunAtLoad = true;
    };
  };
}
