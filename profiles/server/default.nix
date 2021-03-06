{ config, lib, ... }:
{
  imports = [
    ./transmission
  ];
  config = {
    networking.firewall.enable = true;

    services.openssh.enable = true;

    time.timeZone = lib.mkForce "utc";

    services.prometheus.exporters.node.enable = true;
    services.prometheus.exporters.node.openFirewall = true;

    local.immutable.links.etc = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
