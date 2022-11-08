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
