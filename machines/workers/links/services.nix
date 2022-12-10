{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./services/yarr.nix
    ./services/microbin.nix
    ./services/vikunja.nix
  ];

  ############
  ## SHIORI ##
  ############
  services.shiori.enable = true;
  local.consul.services.shiori = {
    name = "shiori";
    port = 8080;
    connect.sidecar_service = {};
  };
  local.proxy.services.shiori = {
    url = "http://localhost:8080";
  };

  ##################################
  ## Persisting state directories ##
  ##################################
  environment.persistence."/nix/persist".directories = [
    "/var/lib/private/shiori"
  ];
}
