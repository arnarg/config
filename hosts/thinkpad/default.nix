{
  self,
  hardware,
  ...
}: {
  system = "x86_64-linux";

  modules = [
    ./configuration.nix
    hardware.nixosModules.common-cpu-amd
    hardware.nixosModules.common-cpu-amd-pstate
    hardware.nixosModules.common-gpu-amd
  ];

  home.modules = [
    ./home.nix
    self.homeModules.development
    self.homeModules.desktop
  ];
}
