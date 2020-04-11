{ config, lib, pkgs, ... }:
let
  cfg = config.local.programs.waybind;
in with lib; {
  options.local.programs.waybind = {
    enable = mkEnableOption "waybind";
    inputDevice = mkOption {
      type = types.str;
      default = "/dev/input/event0";
    };
  };

  config = mkIf cfg.enable {
    # Enable service
    systemd.services.waybind = {
      enable = true;
      description = "Waybind - dead simple key-rebinding";
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.mypkgs.waybind}/bin/waybind";
      serviceConfig.Restart = "always";
      serviceConfig.User = "waybind";
      serviceConfig.Group = "waybind";
      serviceConfig.PrivateNetwork = true;
    };

    # Write config
    environment.etc."waybind/config.yml" = {
      text = ''
        device: ${cfg.inputDevice}
        rebinds:
          - from: KEY_GRAVE
            to: KEY_ESC
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_GRAVE
              - modifier: KEY_LEFTSHIFT
                to: SKIP
        
          - from: KEY_W
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_UP
        
          - from: KEY_S
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_DOWN
        
          - from: KEY_A
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_LEFT
        
          - from: KEY_D
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_RIGHT
        
          - from: KEY_BACKSPACE
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_DELETE
        
          - from: KEY_X
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_PLAY
          
          - from: KEY_Z
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_PREVIOUSSONG
        
          - from: KEY_C
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: KEY_NEXTSONG
        
          - from: KEY_F12
            with_modifiers:
              - modifier: KEY_CAPSLOCK
                to: EXIT
        
          - from: KEY_CAPSLOCK
            unbind: true
      '';
    };

    # Load uinput module
    boot.kernelModules = [ "uinput" ];

    # Add udev rules
    services.udev.packages = [ pkgs.mypkgs.waybind ];

    # Create waybind user
    users.users.waybind = {
      name = "waybind";
      group = "waybind";
      extraGroups = [ "input" "uinput" ];
      createHome = false;
      isSystemUser = true;
    };

    # Create waybind group
    users.groups.waybind = {
      name = "waybind";
    };

    # Create uinput group
    users.groups.uinput = {
      name = "uinput";
    };
  };
}
