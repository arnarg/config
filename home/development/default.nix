{pkgs, ...}: {
  imports = [
    ./git
    ./helix
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
      nurl
      python3
      silver-searcher
      wget
      wireshark
      yubikey-manager

      # Go
      go
      gocode
      godef

      # Gleam
      gleam
      erlang # erlang is needed to compile gleam
      elixir # for elixir dependencies
      rebar3 # sometimes also needed
    ];

    home.sessionVariables = {
      LC_CTYPE = "en_US.UTF-8";
      GOPATH = "$HOME/go";
    };
  };
}
