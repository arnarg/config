{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.microbin = {
    name = "microbin";
    group = "microbin";
    createHome = false;
    isSystemUser = true;
  };
  users.groups.microbin.name = "microbin";

  systemd.services.microbin = let
    pkg = pkgs.microbin;
  in {
    description = "The tiny, self-contained, configurable paste bin.";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${pkg}/bin/microbin --highlightsyntax --port 9080";

      User = "microbin";
      Group = "microbin";

      StateDirectory = "microbin";
      WorkingDirectory = "/var/lib/microbin";
    };
  };

  local.consul.services.bin = {
    name = "bin";
    port = 9080;
    connect.sidecar_service = {};
  };
  local.proxy.services.microbin = {
    name = "bin";
    url = "http://localhost:9080";
  };
}
