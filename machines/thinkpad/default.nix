{inputs, ...}: {
  channelName = "unstable";
  modules = [
    ./configuration.nix
    inputs.self.nixosModules.immutable
    inputs.self.nixosModules.desktop
    inputs.self.nixosModules.development
    inputs.self.nixosModules.laptop
    inputs.self.nixosModules.tpm
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
  ];
}
