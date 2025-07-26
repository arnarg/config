{
  lib,
  pkgs,
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
    programs.git = {
      enable = true;
      userName = "Arnar Gauti Ingason";
      userEmail = "arnarg@fastmail.com";
      difftastic = {
        enable = true;
        display = "inline";
      };
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Arnar Gauti Ingason";
          email = "arnarg@fastmail.com";
        };
        ui = {
          default-command = ["log" "--limit" "10" "--no-pager"];
          diff.tool = ["${pkgs.difftastic}/bin/difft" "--color=always" "--display=inline" "$left" "$right"];
          pager = ":builtin";
          streampager.interface = "quit-if-one-page";
        };
        revsets = {
          log = "ancestors(@)";
        };
      };
    };
  };
}
