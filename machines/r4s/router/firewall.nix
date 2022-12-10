{
  config,
  lib,
  pkgs,
  ...
}: let
  # Creates nftables rules from 'config.firewall.interfaces.<name>.{allowedTCPPorts,allowedUDPPorts}'
  extraOpenPorts = with lib;
    builtins.concatStringsSep "\n" (
      mapAttrsToList (
        interface: vals:
          optionalString (length vals.allowedTCPPorts > 0) (genNFRule interface "tcp" vals.allowedTCPPorts)
          + optionalString (length vals.allowedUDPPorts > 0) (genNFRule interface "udp" vals.allowedUDPPorts)
      )
      config.networking.firewall.interfaces
    );
  genNFRule = with lib;
    iface: proto: ports: ''
      iifname "${iface}" ${proto} dport {${concatMapStrings (p: (toString p) + ",") ports}} counter accept
    '';
in {
  networking = {
    nat.enable = false;
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          chain OUTPUT {
            type filter hook output priority 100; policy accept;
          }

          chain INPUT {
            type filter hook input priority filter; policy drop;

            iifname "lo" counter accept

            # Extra allowed ports specified by nixos config
            ${extraOpenPorts}

            # Allow ipv4 access to SSH only from local network
            ip saddr 192.168.0.0/24 tcp dport ssh counter accept
            # Allow any access from tailscale0 to SSH
            iifname "tailscale0" tcp dport ssh counter accept

            # Allow access to DNS from select interfaces
            iifname {
              "tailscale0",
              "lan0",
            } udp dport 53 counter accept

            # Allow mDNS
            ip saddr {192.168.0.0/24, 10.10.10.0/24} udp dport 5353 counter accept
            ip6 daddr ff02::fb udp dport 5353 counter accept

            # Always allow icmpv6
            ip6 nexthdr icmpv6 icmpv6 type {
              echo-request,
              nd-neighbor-solicit,
              nd-neighbor-advert,
              nd-router-solicit,
              nd-router-advert,
              mld-listener-query,
            } counter accept

            # DHCPv6
            udp dport dhcpv6-client udp sport dhcpv6-server counter accept comment "IPv6 DHCP"

            # Allow returning traffic from wan0 and drop everthing else
            iifname {"wan0", "lan0", "tailscale0"} ct state { established, related } counter accept
            iifname {"wan0", "lan0", "tailscale0"} drop
          }

          chain FORWARD {
            type filter hook forward priority filter; policy drop;

            # Allow icmpv6 ping
            ip6 nexthdr icmpv6 icmpv6 type echo-request counter accept

            # Allow tailscale's wireguard traffic between wan0 and lan0
            iifname {
              "wan0",
              "lan0"
            } oifname {
              "wan0",
              "lan0"
            } udp sport 41641 counter accept comment "Allow wireguard point to point traffic"

            # Allow trusted network WAN access
            iifname {
                    "lan0",
                    "tailscale0",
            } oifname {
                    "wan0",
            } counter accept comment "Allow trusted LAN to WAN"

            # Allow established WAN to return
            iifname {
                    "wan0",
            } oifname {
                    "lan0",
                    "tailscale0",
            } ct state established,related counter accept comment "Allow established back to LANs"
          }
        }

        table ip nat {
          chain PREROUTING {
            type nat hook output priority filter; policy accept;
          }

          # Setup NAT masquerading on the wan0 interface
          chain POSTROUTING {
            type nat hook postrouting priority filter; policy accept;
            oifname "wan0" masquerade
          }
        }
      '';
    };
  };
}
