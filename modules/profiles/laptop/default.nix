{ config, pkgs, lib, ... }:
let
  cfg = config.local.laptop;
in with lib; {
  options.local.laptop = {
    enable = mkEnableOption "laptop";
  };

  imports = [
    ./touch.nix
  ];

  config = mkIf cfg.enable {

    # Enable networkmanager
    networking.networkmanager.enable = true;
    users.users.arnar.extraGroups = [ "networkmanager" ];
  
    # Enable tlp
    services.tlp.enable = true;
    services.tlp.extraConfig = ''
      TLP_DEFAULT_MODE=BAT
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=ondemand
    '';
  
    # Enable light to control backlight
    programs.light.enable = true;
  
    # Add laptop specific config to sway
    local.desktop.sway.extraConfig = with pkgs; ''
      # Enable tap
      input * tap enabled
      # Disable tap and drag
      input * drag disabled
      # Media keys
      bindsym XF86AudioMute exec ${pamixer}/bin/pamixer -t
      bindsym XF86AudioRaiseVolume exec ${pamixer}/bin/pamixer -i 5
      bindsym XF86AudioLowerVolume exec ${pamixer}/bin/pamixer -d 5
      # Brightness
      bindsym XF86MonBrightnessUp exec ${light}/bin/light -A 10
      bindsym XF86MonBrightnessDown exec ${light}/bin/light -U 10
      # I want 50% brightness initially
      exec ${light}/bin/light -S 50
      # Startup programs
      # Enables touchpad gestures
      exec ${libinput-gestures}/bin/libinput-gestures
    '';
  
    # libinput-gestures config
    home-manager.users.arnar.xdg.configFile."libinput-gestures.conf" = {
      text = ''
      gesture: swipe left 3   swaymsg -t command workspace prev_on_output
      gesture: swipe right 3  swaymsg -t command workspace next_on_output
    '';
    };

  };
}
