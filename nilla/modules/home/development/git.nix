{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.development;
in {
  options.profiles.development.git = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git setup.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.git.enable) {
    programs.git.enable = true;
    programs.git.userName = "Arnar Gauti Ingason";
    programs.git.userEmail = "arnarg@fastmail.com";
    programs.git.extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };
}
