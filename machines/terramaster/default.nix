{inputs, ...}: {
  modules = [
    ./configuration.nix
    inputs.self.nixosModules.immutable
    inputs.self.nixosModules.server
  ];
}
