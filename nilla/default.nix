{config}: {
  includes = [
    ./lib/hosts.nix
    ./lib/inputs.nix
  ];

  config.generators.nixos.modules = [
    {
      # Set nixpkgs in registry.json
      nix.registry.nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = {
          type = "path";
          path = config.inputs.nixpkgs.src;
        };
      };

      # Set NIX_PATH to /etc/nix/inputs and create those symlinks
      nix.nixPath = ["/etc/nix/inputs"];
      environment.etc = builtins.listToAttrs (config.lib.attrs.mapToList (n: val: {
          name = "nix/inputs/${n}";
          value.source = val.src;
        })
        config.inputs);
    }
  ];
}
