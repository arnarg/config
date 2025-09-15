{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.development;
in
{
  options.profiles.development = with lib; {
    enable = mkEnableOption "development profile";
  };

  config = lib.mkIf cfg.enable {
    # Setup podman.
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true;
    virtualisation.podman.dockerSocket.enable = true;

    users.users.arnar.extraGroups = [ "podman" ];
    users.users.arnar.subUidRanges = [
      {
        count = 65536;
        startUid = 100000;
      }
    ];
    users.users.arnar.subGidRanges = [
      {
        count = 65536;
        startGid = 100000;
      }
    ];

    # Use zsh for default shell.
    users.users.arnar.shell = pkgs.zsh;
    programs.zsh.enable = true;
  };
}
