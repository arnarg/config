# This is inspired by https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
{ config, pkgs, lib, ... }:
let
  cfg = config.local.immutable;
in with lib; {
  options.local.immutable = {
    enable = mkEnableOption "immutable";

    device = mkOption {
      type = types.str;
      default = "/dev/mapper/enc";
      description = "Path to immutable device.";
    };

    rootSubvolume = mkOption {
      type = types.str;
      default = "root";
      description = "Name of the root subvolume.";
    };

    rootBlankSubvolume = mkOption {
      type = types.str;
      default = "root-blank";
      description = "Name of the empty root subvolume.";
    };

    persistPath = mkOption {
      type = types.str;
      default = "/persist";
      description = "Path to a persisted folder.";
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

    # Persisting user passwords
    users.mutableUsers = false;
    fileSystems."${cfg.persistPath}".neededForBoot = true;
    users.users = mkMerge (
      [ { root.passwordFile = "${cfg.persistPath}/passwords/root"; } ] ++
      forEach cfg.users (u:
        { "${u}".passwordFile = "${cfg.persistPath}/passwords/${u}"; }
      )
    );

    # Rollback to blank snapshot
    boot.initrd.postDeviceCommands = mkBefore ''
      mkdir -p /mnt

      mount -o subvol=/ ${cfg.device} /mnt

      btrfs subvolume list -o /mnt/${cfg.rootSubvolume} |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /${cfg.rootSubvolume} subvolume..." &&
      btrfs subvolume delete /mnt/${cfg.rootSubvolume}

      echo "restoring blank /${cfg.rootSubvolume} subvolume..."
      btrfs subvolume snapshot /mnt/${cfg.rootBlankSubvolume} /mnt/${cfg.rootSubvolume}

      umount /mnt
    '';
  };
}
