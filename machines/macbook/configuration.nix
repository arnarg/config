{ config, lib, pkgs, ... }:
let
  homeDir = builtins.getEnv("HOME");
in with lib; {
  imports = [
    <home-manager/nix-darwin>
    ../../modules/nixpkgs.nix
    ../../modules/home.nix
    ../../modules/kr.nix
  ];

  environment = {
    darwinConfig = "${homeDir}/Code/config/machines/macbook/configuration.nix";
    shells = [ pkgs.zsh ];
  };

  local = {
    home.git.userEmail = "arnari@wuxinextcode.com";
    home.userName = "arnari";
    home.enableFirefox = false;
    zsh.enableOktaAws = true;
  };

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
  programs.zsh.enable = true;
  programs.zsh.enableSyntaxHighlighting = true;

  services.krypton.krd.enable = true;

  services.nix-daemon.enable = true;
  services.nix-daemon.enableSocketListener = true;

  services.activate-system.enable = true;

  nix.maxJobs = 12;
  nix.buildCores = 1;

  system.stateVersion = 4;
}
