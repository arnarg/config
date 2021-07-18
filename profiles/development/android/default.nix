{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.android;
in with lib; {
  options.local.development.android = {
    enable = mkEnableOption "android";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;

    environment.systemPackages = with pkgs; [
      android-studio
      android-udev-rules

      nodePackages.react-native-cli
    ];
  };
}
