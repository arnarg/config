{ config, lib, pkgs, ... }:
let
  homeDir = builtins.getEnv("HOME");
in with lib; {
  imports = [
    <home-manager/nix-darwin>
    ../../modules
    ../../modules/os-specific/darwin.nix
  ];

  environment = {
    darwinConfig = "${homeDir}/Code/config/machines/macbook/configuration.nix";
    shells = [ pkgs.zsh ];
  };

  local.userName = "arnari";
  local.development.enable = true;
  local.development.git.userEmail = "arnari@wuxinextcode";
  local.development.zsh.enableOktaAws = true;

  home-manager.users.arnari.home = {
    packages = with pkgs; [
      awscli
      python37
      python37Packages.virtualenv
      python37Packages.pip
      terraform
    ];
    sessionVariables = {
      # Set external paths
      # I still have some packages in macports
      PATH = "/opt/local/bin:$PATH";
    };
  };

  programs.bash.enable = true;

  services.nix-daemon.enable = true;
  services.nix-daemon.enableSocketListener = true;

  services.activate-system.enable = true;

  nix.maxJobs = 12;
  nix.buildCores = 1;

  system.stateVersion = 4;
}
