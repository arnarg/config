{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    libinput-gestures
  ];

  users.users.arnar.extraGroups = [ "networkmanager" ];

  networking.networkmanager.enable = true;

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    TLP_DEFAULT_MODE=BAT
    CPU_SCALING_GOVERNOR_ON_AC=performance
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
  '';

  programs.light.enable = true;

  services.upower.enable = true;

  local.desktop.isLaptop = true;
  local.desktop.isHiDPI = lib.mkDefault false;
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

  home-manager.users.arnar.xdg.configFile."libinput-gestures.conf" = {
    text = ''
    gesture: swipe left 3   swaymsg -t command workspace prev_on_output
    gesture: swipe right 3  swaymsg -t command workspace next_on_output
  '';
  };
}
