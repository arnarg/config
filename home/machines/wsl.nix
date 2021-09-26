{ config, inputs, ... }:
{
  home.packages = [
    inputs.home.packages.x86_64-linux.home-manager
    inputs.nixpkgs.legacyPackages.x86_64-linux.nixUnstable
  ];
  home.sessionVariables = {
    DOCKER_HOST = "tcp://localhost:2375";
  };
  programs.zsh.envExtra = ''
    source $HOME/.nix-profile/etc/profile.d/nix.sh
  '';
}
