{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = "cdbrdr.com";
  tsInterface = config.services.tailscale.interfaceName;
in {
  services.coredns.enable = true;
  services.coredns.config = ''
    ${domain} {
      bind ${tsInterface}
      hosts /tmp/coredns/hosts {
        reload 10s
      }
      log
      errors
    }
  '';
  systemd.services.coredns.serviceConfig.BindReadOnlyPaths = [
    "/tmp/coredns"
  ];

  environment.etc."coredns/hosts.tmpl".text = ''
    {{- range services }}
    {{- if not (.Name | regexMatch "-sidecar-proxy$") }}
    {{- $name := .Name }}
    {{- range sockaddr "GetInterfaceIPs \"${tsInterface}\"" | split " "}}
    {{ . }} {{ $name }}.${domain}
    {{- end}}
    {{- end }}
    {{- end }}
  '';

  systemd.tmpfiles.rules = [
    "f /tmp/coredns/hosts 0644 root root"
  ];

  systemd.services.hosts-consul-template = {
    description = "Consul template service to generate hosts file from services";
    wantedBy = ["multi-user.target"];
    requires = ["network-online.target"];
    after = ["network-online.target" "consul.service"];

    serviceConfig = {
      ExecStart = "${pkgs.consul-template}/bin/consul-template --template=\"/etc/coredns/hosts.tmpl:/tmp/coredns/hosts\"";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
      KillSignal = "SIGINT";
      Restart = "always";
    };
  };
}
