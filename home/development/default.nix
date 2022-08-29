{
  config,
  lib,
  pkgs,
  ...
}: {
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

    home.sessionVariables = {
      ZK_NOTEBOOK_DIR = "$HOME/Documents/notes";
      LC_CTYPE = "en_US.UTF-8";
      GOPATH = "$HOME/go";
    };
  };
}
