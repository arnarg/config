{pkgs, ...}: let
  cs-firewall-bouncer = pkgs.buildGoModule rec {
    pname = "cs-firewall-bouncer";
    version = "0.0.33";

    src = pkgs.fetchFromGitHub {
      owner = "crowdsecurity";
      repo = "cs-firewall-bouncer";
      rev = "v${version}";
      hash = "sha256-4fxxAW2sXGNxjsc75fd499ciuN8tjGqlpRIaHYUXwQ0=";
    };

    vendorHash = "sha256-Bhp6Z2UlCJ32vdc3uINCGleZFP2WeUn/XK+Q29szUzQ=";

    ldflags = [
      "-X 'github.com/crowdsecurity/go-cs-lib/version.Version=v${version}'"
      "-X 'github.com/crowdsecurity/go-cs-lib/version.Tag=v${version}'"
    ];
  };
in {
  config = {
    environment.systemPackages = with pkgs; [
      crowdsec
    ];

    systemd.services.crowdsec = {
      description = "Crowdsec agent";
      after = ["syslog.target" "network.target" "remote-fs.target" "nss-lookup.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        LC_ALL = "C";
        LANG = "C";
      };

      serviceConfig = {
        ExecStartPre = "${pkgs.crowdsec}/bin/crowdsec -c /etc/crowdsec/config.yaml -t -error";
        ExecStart = "${pkgs.crowdsec}/bin/crowdsec -c /etc/crowdsec/config.yaml";
        ExecReload = [
          "${pkgs.crowdsec}/bin/crowdsec -c /etc/crowdsec/config.yaml -t -error"
          "${pkgs.util-linux}/bin/kill -HUP $MAINPID"
        ];
        Restart = "always";
        RestartSec = 60;
      };
    };

    environment.etc."crowdsec/bouncers/firewall/config.yaml".text = ''
      mode: iptables
      update_frequency: 10s
      log_mode: stdout
      log_level: info
      api_url: http://127.0.0.1:8080/
      deny_action: DROP
      deny_log: false
      supported_decisions_types:
        - ban
      blacklists_ipv4: crowdsec-blacklists
      blacklists_ipv6: crowdsec6-blacklists
      ipset_type: nethash
      iptables_chains:
        - INPUT
      iptables_add_rule_comments: true

      prometheus:
        enabled: false
        listen_addr: 127.0.0.1
        listen_port: 60601
    '';

    systemd.services.crowdsec-firewall-bouncer = {
      description = "The firewall bouncer for crowdsec";
      after = ["syslog.target" "network.target" "remote-fs.target" "nss-lookup.target" "crowdsec.service"];
      wantedBy = ["multi-user.target"];

      path = with pkgs; [
        iptables
        ipset
      ];

      serviceConfig = {
        ExecStart = "${cs-firewall-bouncer}/bin/cs-firewall-bouncer -c /etc/crowdsec/bouncers/firewall/config.yaml";
        ExecStartPre = "${cs-firewall-bouncer}/bin/cs-firewall-bouncer -c /etc/crowdsec/bouncers/firewall/config.yaml -t";
        ExecStartPost = "${pkgs.coreutils}/bin/sleep 0.1";
        Restart = "always";
        RestartSec = 10;
        LimitNOFILE = 65536;
        KillMode = "mixed";
      };
    };
  };
}
