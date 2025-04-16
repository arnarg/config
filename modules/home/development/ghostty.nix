{
  lib,
  config,
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
    programs.ghostty.enable = true;
    programs.ghostty.enableZshIntegration = false;
    programs.ghostty.installBatSyntax = true;
    programs.ghostty.settings = {
      theme = "GruvboxDark";

      font-family = "Inconsolata";
      font-size = toString (builtins.floor (12 * sf));

      cursor-style = "block";
      cursor-style-blink = true;

      # Disable font ligatures
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];

      # Unbind alt+<number> to allow tmux
      # to handle that
      keybind = [
        "alt+one=unbind"
        "alt+two=unbind"
        "alt+three=unbind"
        "alt+four=unbind"
        "alt+five=unbind"
        "alt+six=unbind"
        "alt+seven=unbind"
        "alt+eight=unbind"
        "alt+nine=unbind"
      ];
    };

    dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      command = lib.mkForce "ghostty";
    };
  };
}
