let
  inherit (builtins) readDir hasAttr attrNames filter concatMap listToAttrs;

  loadHosts = dir: inputs: let
    loadConf = dir: n:
      (import "${dir}/${n}" inputs)
      // {hostname = n;};

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
        hasDefault = (hasAttr "default.nix" contents) && (contents."default.nix" == "regular");
      in
        if hasDefault
        then [(loadConf dir n)]
        else []
    )
    hosts';
in {
  # Discover NixOS configurations.
  # It will find all sub-directories in `directory` and
  # include it if it has a default.nix.
  genNixOSHosts = {
    inputs,
    directory ? "${inputs.self}/hosts",
    nixpkgs ? inputs.nixpkgs,
    builder ? nixpkgs.lib.nixosSystem,
    specialArgs ? {},
    baseModules ? [],
    overlays ? [],
    config ? {allowUnfree = true;},
  }: let
    mkHost = {
      system,
      modules,
      hostname,
    }:
      builder {
        inherit system;

        specialArgs = {inherit inputs;} // specialArgs;

        modules =
          [
            ({...}: {
              networking.hostName = hostname;

              nixpkgs = {
                inherit overlays config;
              };
            })
          ]
          ++ baseModules
          ++ modules;
      };
  in
    listToAttrs (map (conf: {
        name = conf.hostname;
        value = mkHost (removeAttrs conf ["home"]);
      })
      (loadHosts directory inputs));

  # Discover home-manager configurations.
  # It will find all sub-directories in `directory` and
  # include it if it has a default.nix.
  genHomeHosts = {
    inputs,
    user,
    directory ? "${inputs.self}/hosts",
    nixpkgs ? inputs.nixpkgs,
    home ? inputs.home,
    builder ? home.lib.homeManagerConfiguration,
    specialArgs ? {},
    baseModules ? [],
    overlays ? [],
    config ? {allowUnfree = true;},
  }: let
    homeHosts =
      concatMap
      (
        h:
          if (hasAttr "home" h)
          then [((removeAttrs h ["home" "modules"]) // h.home)]
          else []
      )
      (loadHosts directory inputs);

    mkHost = {
      system,
      modules,
      hostname,
    }: let
      pkgs = import nixpkgs {
        inherit system config overlays;
      };
    in
      builder {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;} // specialArgs;

        modules =
          [
            ({lib, ...}: {
              home.username = lib.mkDefault user;
              home.homeDirectory = lib.mkDefault "/home/${user}";
            })
          ]
          ++ baseModules
          ++ modules;
      };
  in
    listToAttrs (map (conf: {
        name = "${user}@${conf.hostname}";
        value = mkHost conf;
      })
      homeHosts);
}
