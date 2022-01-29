{ config, lib, pkgs, ... }:
{
  imports = [
    ./git
    ./gpg
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

      # Go
      go
      gocode
      godef
    ];
  };
}
