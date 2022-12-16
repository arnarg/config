{config, ...}: {
  # Enable tailscale
  services.tailscale.enable = true;

  environment.persistence."/nix/persist".directories = [
    "/var/lib/tailscale"
  ];

  networking.firewall.allowedUDPPorts = [
    config.services.tailscale.port
  ];
  networking.firewall.checkReversePath = "loose";
}
