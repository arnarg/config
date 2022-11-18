{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./services/yarr.nix
    ./services/microbin.nix
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

  ##################################
  ## Persisting state directories ##
  ##################################
  environment.persistence."/nix/persist".directories = [
    "/var/lib/private/shiori"
  ];
}
