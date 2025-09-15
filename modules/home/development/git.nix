{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.profiles.development;
in
{
  options.profiles.development.git = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git setup.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.git.enable) {
    home.packages = with pkgs; [
      jjui
    ];

    programs.git = {
      enable = true;
      userName = "Arnar Gauti Ingason";
      userEmail = "arnarg@fastmail.com";
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
        core.excludesFile = builtins.toString (
          pkgs.writeText "git-excludes-file" ''
            # All crush state keeping
            .crush/
          ''
        );
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
          default-command = [
            "log"
            "-r"
            "default() & recent()"
          ];
          diff.tool = [
            "${pkgs.difftastic}/bin/difft"
            "--color=always"
            "$left"
            "$right"
          ];
          pager = ":builtin";
          streampager.interface = "quit-if-one-page";
        };
        revsets = {
          log = "ancestors(@)";
        };
        aliases = {
          rtr = [
            "rebase"
            "-d"
            "trunk()"
          ];
          fresh = [
            "new"
            "trunk()"
          ];
          tug = [
            "bookmark"
            "move"
            "--from"
            "closest_bookmark(@)"
            "--to"
            "closest_pushable(@)"
          ];
        };
        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "closest_pushable(to)" =
            "heads(::to & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
          "default()" =
            "coalesce(trunk(),root())::present(@) | ancestors((visible_heads() | reachable(@, mutable())) & recent(), 5)";
          "recent()" = "committer_date(after:\"1 month ago\")";
        };
        template-aliases = {
          "format_short_change_id(id)" = "id.shortest(4)";
          "format_short_commit_id(id)" = "id.shortest(6)";
        };
      };
    };
  };
}
