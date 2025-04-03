{config}: let
  inherit (builtins) readDir hasAttr attrNames filter concatMap listToAttrs;

  loadHosts = dir: let
    hosts' = let
      contents = readDir dir;
    in
      filter
      (n: contents."${n}" == "directory")
      (attrNames contents);
  in
    concatMap
    (
      n: let
        contents = readDir "${dir}/${n}";
        hasConfig =
          (hasAttr "configuration.nix" contents)
          && (contents."configuration.nix" == "regular");
      in
        if hasConfig
        then [
          {
            hostname = n;
            configuration = import "${dir}/${n}/configuration.nix";
          }
        ]
        else []
    )
    hosts';
in {
  options.generators.nixos = with config.lib; {
    folder = options.create {
      type = types.path;
      description = "The folder to auto discover NixOS hosts.";
    };
    modules = options.create {
      type = types.list.of types.raw;
      default.value = [];
      description = "Default modules to include in all hosts.";
    };
  };

  config = {
    systems.nixos = listToAttrs (map (host: {
      name = host.hostname;
      value = {
        modules =
          [
            host.configuration
            {
              # Automatically set hostname
              networking.hostName = host.hostname;
            }
          ]
          ++ config.generators.nixos.modules;
      };
    }) (loadHosts config.generators.nixos.folder));
  };
}
