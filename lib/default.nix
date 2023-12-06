let
  loadHosts = dir: inputs: let
    loadConf = dir: n:
      (import "${dir}/${n}" inputs)
      // {hostname = n;};

    hosts' = let
      contents = builtins.readDir dir;
    in
      builtins.filter
      (n: contents."${n}" == "directory")
      (builtins.attrNames contents);
  in
    builtins.concatMap
    (
      n: let
        contents = builtins.readDir "${dir}/${n}";
        hasDefault = (builtins.hasAttr "default.nix" contents) && (contents."default.nix" == "regular");
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
    builtins.listToAttrs (builtins.map (conf: {
        name = conf.hostname;
        value = mkHost (builtins.removeAttrs conf ["home"]);
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
      builtins.concatMap
      (
        h:
          if (builtins.hasAttr "home" h)
          then [((builtins.removeAttrs h ["home" "modules"]) // h.home)]
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
    builtins.listToAttrs (builtins.map (conf: {
        name = "${user}@${conf.hostname}";
        value = mkHost conf;
      })
      homeHosts);
}
