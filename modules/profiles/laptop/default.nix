{ config, pkgs, lib, ... }:
let
  cfg = config.local.laptop;
in with lib; {
  options.local.laptop = {
    enable = mkEnableOption "laptop";
  };

  imports = [
    ./touch.nix
    ./tablet.nix
  ];

  config = mkIf cfg.enable {

    # Enable UPower to watch battery stats
    services.upower.enable = true;

    # Enable networkmanager
    networking.networkmanager.enable = true;
    users.users.arnar.extraGroups = [ "networkmanager" ];
    environment.systemPackages = with pkgs; [ networkmanager-openvpn ];
  
    # Enable tlp
    services.tlp.enable = true;
    services.tlp.extraConfig = ''
      TLP_DEFAULT_MODE=BAT
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=ondemand
    '';
  
    # Enable light to control backlight
    programs.light.enable = true;

    # Enable waybind key rebinder
    local.programs.waybind.enable = true;
  
    # Add laptop specific config to sway
    home-manager.users.arnar.wayland.windowManager.sway = {
      config = {
        input = {
          "*" = { tap = "enabled"; drag = "disabled"; };
        };

        keybindings = with pkgs; {
          "XF86AudioMute" = "exec ${pamixer}/bin/pamixer -t";
          "XF86AudioRaiseVolume" = "exec ${pamixer}/bin/pamixer -i 5";
          "XF86AudioLowerVolume" = "exec ${pamixer}/bin/pamixer -d 5";
          "XF86MonBrightnessUp" = "exec ${light}/bin/light -A 10";
          "XF86MonBrightnessDown" = "exec ${light}/bin/light -U 10";
        };

        startup = [
          { command = "${pkgs.libinput-gestures}/bin/libinput-gestures"; }
          { command = "${pkgs.light}/bin/light -S 50"; }
          { command = "${pkgs.go-upower-notify}/bin/upower-notify"; }
        ];
      };
      extraConfig = ''
        bindswitch lid:on output eDP-1 disable
        bindswitch lid:off output eDP-1 enable
      '';
    };
  
    # libinput-gestures config
    home-manager.users.arnar.xdg.configFile."libinput-gestures.conf" = {
      text = ''
      gesture: swipe left 3   swaymsg -t command workspace prev_on_output
      gesture: swipe right 3  swaymsg -t command workspace next_on_output
    '';
    };

  };
}
