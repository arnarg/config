{config}: let
  inherit (builtins) readDir hasAttr attrNames filter concatMap listToAttrs;

  loadHosts = dir: file: let
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
          (hasAttr file contents)
          && (contents.${file} == "regular");
      in
        if hasConfig
        then [
          {
            hostname = n;
            configuration = import "${dir}/${n}/${file}";
          }
        ]
        else []
    )
    hosts';
in {
  options.generators = with config.lib; {
    nixos = {
      folder = options.create {
        type = types.path;
        description = "The folder to auto discover NixOS hosts.";
      };
      args = options.create {
        description = "Additional arguments to pass to system modules.";
        type = types.attrs.any;
        default.value = {};
      };
      modules = options.create {
        type = types.list.of types.raw;
        default.value = [];
        description = "Default modules to include in all hosts.";
      };
    };
    home = {
      username = options.create {
        type = types.string;
        description = "The username to use for all discovered home-manager hosts.";
      };
      folder = options.create {
        type = types.path;
        description = "The folder to auto discover home-manager hosts.";
      };
      args = options.create {
        description = "Additional arguments to pass to home-manager modules.";
        type = types.attrs.any;
        default.value = {};
      };
      modules = options.create {
        type = types.list.of types.raw;
        default.value = [];
        description = "Default modules to include in all hosts.";
      };
    };
  };

  config = {
    systems.nixos = listToAttrs (map (host: {
      name = host.hostname;
      value = {
        inherit (config.generators.nixos) args;
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
    }) (loadHosts config.generators.nixos.folder "configuration.nix"));

    systems.home = listToAttrs (map (host: {
      name = "${config.generators.home.username}@${host.hostname}";
      value = {
        inherit (config.generators.home) args;
        modules =
          [
            host.configuration
            {
              home.username = config.generators.home.username;
              home.homeDirectory = "/home/${config.generators.home.username}";
            }
          ]
          ++ config.generators.home.modules;
      };
    }) (loadHosts config.generators.home.folder "home.nix"));
  };
}
