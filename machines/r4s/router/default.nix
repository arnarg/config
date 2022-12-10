{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./firewall.nix
    ./dns.nix
    ./proxy.nix
    ./consul.nix
    ./vault.nix
  ];

  ############
  ## SYSCTL ##
  ############
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;

    # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;

    # On WAN, allow IPv6 autoconfiguration and tempory address use.
    "net.ipv6.conf.wan0.accept_ra" = 2;
    "net.ipv6.conf.wan0.autoconf" = 1;
  };

  #################
  ## DHCP CLIENT ##
  #################
  networking.dhcpcd = {
    enable = true;
    # Do not remove interface configuration on shutdown.
    persistent = true;
    extraConfig = ''
      # generate a RFC 4361 complient DHCP ID
      duid

      # We don't want to expose our hw addr from the router to the internet,
      # so we generate a RFC7217 address.
      slaac private

      # settings for the interface
      interface wan0
        ipv6rs              # router advertisement solicitaion
        iaid 1              # interface association ID
        ia_pd 1 lan0      # request a PD and assign to interface
    '';
  };

  #################
  ## DHCP SERVER ##
  #################
  services.dhcpd4 = {
    enable = true;
    interfaces = ["lan0"];
    extraConfig = ''
      option domain-name-servers 1.1.1.1, 1.0.0.1;
      option subnet-mask 255.255.255.0;

      subnet 10.10.10.0 netmask 255.255.255.0 {
        option broadcast-address 10.10.10.255;
        option routers 10.10.10.1;
        interface lan0;
        range 10.10.10.10 10.10.10.254;
      }
    '';
  };

  #############
  ## CORERAD ##
  #############
  services.corerad = {
    enable = true;
    settings = {
      interfaces = [
        {
          name = "wan0";
          monitor = false;
        }
        {
          name = "lan0";
          advertise = true;
          prefix = [
            {prefix = "::/64";}
          ];
        }
      ];
    };
  };
}
