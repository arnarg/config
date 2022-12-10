{
  config,
  lib,
  pkgs,
  ...
}: {
  services.vikunja = {
    enable = true;
    frontendHostname = "todo.cdbrdr.com";
    frontendScheme = "https";
    settings = {
      service = {
        enablecaldav = true;
        enableregistration = false;
      };
    };
  };

  services.nginx.enable = true;

  local.consul.services.todo = {
    name = "todo";
    port = 80;
    connect.sidecar_service = {};
  };
  local.proxy.services.todo = {
    url = "http://localhost:80";
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/private/vikunja"
  ];
}
