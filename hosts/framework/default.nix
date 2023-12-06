{
  self,
  hardware,
  ...
}: {
  system = "x86_64-linux";

  modules = [
    ./configuration.nix
    hardware.nixosModules.framework-12th-gen-intel
  ];

  home.modules = [
    ./home.nix
    self.homeModules.development
    self.homeModules.desktop
  ];
}
