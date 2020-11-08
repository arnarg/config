# This is inspired by https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
{ config, pkgs, lib, ... }:
let
  cfg = config.local.immutable;
in with lib; {
  options.local.immutable = {
    enable = mkEnableOption "immutable";
    persistPath = mkOption {
      type = types.str;
      default = "/persist";
      description = "Path to a persisted folder.";
    };
    persistDevice = mkOption {
      type = types.str;
      default = cfg.persistPath;
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

  config = mkIf cfg.enable {
    # Files to persist between boots
    environment.etc = mkMerge (map (p:
      { "${strings.removePrefix "/etc/" p}" = { source = "${cfg.persistPath}${p}"; }; }
    ) cfg.links.etc );
    systemd.tmpfiles.rules = map (p:
      "L ${p} - - - - ${cfg.persistPath}${p}"
    ) cfg.links.tmpfiles;

    # Disable sudo nag
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    # Empty user's Download folder
    boot.postBootCommands = concatStringsSep "\n" (map (u:
      "rm -rf ${config.users.users.${u}.home}/Downloads/* || true"
    ) cfg.users);

    # Persisting user passwords
    users.mutableUsers = false;
    fileSystems."${cfg.persistDevice}".neededForBoot = true;
    users.users = mkMerge (
      [ { root.passwordFile = "${cfg.persistPath}/passwords/root"; } ] ++
      forEach cfg.users (u:
        { "${u}".passwordFile = "${cfg.persistPath}/passwords/${u}"; }
      )
    );

  };
}
