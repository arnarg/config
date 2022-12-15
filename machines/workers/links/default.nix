{inputs, ...}: {
  system = "aarch64-linux";
  modules = [
    ./configuration.nix
    inputs.self.nixosModules.immutable
    inputs.self.nixosModules.server
  ];
}
