{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.server;
in {
  options.profiles.server = with lib; {
    enable = mkEnableOption "server profile";
  };

  config = lib.mkIf cfg.enable {
    # Enable openssh server.
    services.openssh.enable = true;

    # Server should always use UTC timezone.
    time.timeZone = lib.mkForce "utc";

    # Setup persistence.
    profiles.immutable.files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
