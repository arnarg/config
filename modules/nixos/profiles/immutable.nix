{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.profiles.immutable;
in {
  imports = [
    "${inputs.impermanence.result}/nixos.nix"
  ];

  options.profiles.immutable = with lib; {
    enable = mkEnableOption "immutable profile";
    device = mkOption {
      type = types.str;
      default = "/nix";
      description = "The device the persisted folder is on.";
    };
    path = mkOption {
      type = types.str;
      default = "${config.profiles.immutable.device}/persist";
      description = "Path to the persistance folder.";
    };
    directories = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of directories that should be persisted.";
    };
    files = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of files that should be persisted.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Disable sudo nag.
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    # Persisting user password.
    users.mutableUsers = false;
    fileSystems."${cfg.device}".neededForBoot = true;
    users.users = {
      root.hashedPasswordFile = "${cfg.path}/passwords/root";
      arnar.hashedPasswordFile = "${cfg.path}/passwords/arnar";
    };

    # Pass persisted paths to impermanence module.
    environment.persistence."${cfg.path}" = {
      hideMounts = true;
      directories = cfg.directories;
      files = cfg.files;
    };
  };
}
