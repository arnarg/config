{ config, lib, pkgs, ... }:
{
  imports = [
    ./git
    ./neovim
    ./pass
    ./tmux
    ./zsh
  ];

  config = {
    home.packages = with pkgs; [
      cachix
      curl
      dnsutils
      htop
      jq
      nix-prefetch-github
      python3
      silver-searcher
      wget
      wireshark
      yubikey-manager
      zk

      # Go
      go
      gocode
      godef
    ];

    programs.zsh.sessionVariables = {
      ZK_NOTEBOOK_DIR = "$HOME/Documents/notes";
    };
  };
}
