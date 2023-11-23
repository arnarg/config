# This is inspired by https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.local.immutable;
in
  with lib; {
    options.local.immutable = {
      persistPath = mkOption {
        type = types.str;
        default = "${cfg.persistDevice}/persist";
        description = "Path to a persisted folder.";
      };
      persistDevice = mkOption {
        type = types.str;
        default = "/nix";
        description = "The device the persisted folder is on.";
      };
      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of users that should use passwordFile \${persistPath}/passwords/\${user}.";
      };
      links = {
        etc = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "List of files and folders that should be linked using environment.etc.*.source.";
        };

        tmpfiles = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "List of files and folders that should be linked using systemd.tmpfiles.rules.";
        };
      };
    };

    config = {
      local.immutable.users = ["arnar"];

      # Files to persist between boots
      environment.etc = mkMerge (map (
          p: {"${strings.removePrefix "/etc/" p}" = {source = "${cfg.persistPath}${p}";};}
        )
        cfg.links.etc);
      systemd.tmpfiles.rules =
        map (
          p: "L ${p} - - - - ${cfg.persistPath}${p}"
        )
        cfg.links.tmpfiles;

      # Disable sudo nag
      security.sudo.extraConfig = ''
        Defaults lecture = never
      '';

      # Persisting user passwords
      users.mutableUsers = false;
      fileSystems."${cfg.persistDevice}".neededForBoot = true;
      users.users = mkMerge (
        [{root.hashedPasswordFile = "${cfg.persistPath}/passwords/root";}]
        ++ forEach cfg.users (
          u: {"${u}".hashedPasswordFile = "${cfg.persistPath}/passwords/${u}";}
        )
      );
    };
  }
