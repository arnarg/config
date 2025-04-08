{
  config = {
    # Set NixOS and Home Manager modules
    modules.nixos.default = ./modules/nixos;
    modules.home.default = ./modules/home;

    # Set overlay
    overlays.default = import ../packages/overlay.nix;
  };
}
