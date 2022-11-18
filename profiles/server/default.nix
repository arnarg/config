{
  config,
  lib,
  ...
}: {
  imports = [
    ./fancontrol
    ./grafana
    ./prometheus
  ];
  config = {
    networking.firewall.enable = lib.mkDefault true;

    services.openssh.enable = true;

    time.timeZone = lib.mkForce "utc";

    services.prometheus.exporters.node.enable = true;
    services.prometheus.exporters.node.openFirewall = true;

    # Files to persist on servers with immutable profile turned on
    environment.persistence."${config.local.immutable.persistPath}" = {
      hideMounts = true;
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };
}
