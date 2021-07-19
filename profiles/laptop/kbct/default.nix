{ config, lib, pkgs, ... }:
let
  cfg = config.local.laptop.kbct;
  kbctConfig = pkgs.writeText "kbct.yaml" ''
    - keyboards:
      - ${cfg.inputDevice}
      keymap:
        grave: esc
        capslock: reserved
      layers:
      - modifiers:
        - capslock
        keymap:
          grave: grave
          w: up
          s: down
          a: left
          d: right
          backspace: delete
          z: previoussong
          x: playpause
          c: nextsong
  '';
in with lib; {
  options.local.laptop.kbct = {
    enable = mkEnableOption "kbct";
    inputDevice = mkOption {
      type = types.str;
      default = "AT Translated Set 2 keyboard";
    };
  };

  config = mkIf cfg.enable {
    # Enable service
    systemd.services.kbct = {
      enable = true;
      description = "Keyboard keycode mapping utility for Linux supporting layered configuration";
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.kbct}/bin/kbct remap -c ${kbctConfig}";
      serviceConfig.Restart = "always";
      serviceConfig.PrivateNetwork = true;
      serviceConfig.ProtectSystem = "strict";
      serviceConfig.ProtectHome = "read-only";
      serviceConfig.ProtectTmp = true;
    };

    # Load uinput module
    boot.kernelModules = [ "uinput" ];

    # Add udev rule
    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="uinput", MODE:="0660"
    '';

    # Create kbct user
    users.users.kbct = {
      name = "kbct";
      group = "kbct";
      extraGroups = [ "input" "uinput" ];
      createHome = false;
      isSystemUser = true;
    };

    # Create kbct group
    users.groups.kbct = {
      name = "kbct";
    };

    # Create uinput group
    users.groups.uinput = {
      name = "uinput";
    };
  };
}
