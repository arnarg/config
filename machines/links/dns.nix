{
  config,
  lib,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  tsInterface = config.services.tailscale.interfaceName;
  services = config.local.proxy.services;

  domain = "cdbrdr.com";
  hostAddr = "100.74.160.116";

  records =
    lib.concatMapStringsSep "\n" (
      c: "${hostAddr} ${c.name}.${domain}"
    )
    services;
in {
  services.coredns.enable = true;
  services.coredns.config = ''
    ${domain} {
      bind ${tsInterface}
      hosts {
        ${records}
        fallthrough
      }
      forward . tls://1.1.1.1 tls://1.0.0.1 {
        tls_servername cloudflare-dns.com
        health_check 5s
      }
      log
      errors
    }
  '';

  ##############
  ## Firewall ##
  ##############
  # Only expose over tailscale interface
  networking.firewall.interfaces."${tsInterface}".allowedUDPPorts = [
    53
  ];
}
