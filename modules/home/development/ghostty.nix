{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.development;
  sf = config.profiles.desktop.gnome.textScalingFactor;
in {
  options.profiles.development.ghostty = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable tmux setup";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.ghostty.enable) {
    home.packages = with pkgs; [
      ghostty
    ];

    dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      command = lib.mkForce "ghostty";
    };

    xdg.configFile."ghostty/config".text = ''
      font-family = Inconsolata
      font-size = ${toString (builtins.floor (12 * sf))}
      theme = GruvboxDark
      cursor-style = block

      # Disable font ligatures
      font-feature = -calt
      font-feature = -liga
      font-feature = -dlig

      # Unbind alt+<number> to allow tmux
      # to handle that
      keybind = alt+one=unbind
      keybind = alt+two=unbind
      keybind = alt+three=unbind
      keybind = alt+four=unbind
      keybind = alt+five=unbind
      keybind = alt+six=unbind
      keybind = alt+seven=unbind
      keybind = alt+eight=unbind
      keybind = alt+nine=unbind
    '';
  };
}
