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
  genNixOSHosts = {
    inputs,
    nixpkgs,
    directory,
    specialArgs ? {},
    baseModules ? [],
    overlays ? [],
    config ? {},
  }: let
    mkHost = {
      system,
      modules,
      hostname,
    }:
      nixpkgs.lib.nixosSystem {
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

  genHomeHosts = {
    inputs,
    nixpkgs,
    home,
    directory,
    user,
    specialArgs ? {},
    baseModules ? [],
    overlays ? [],
    config ? {},
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
      home.lib.homeManagerConfiguration {
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
