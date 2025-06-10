{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.development;
in {
  imports = [
    ./aichat.nix
    ./aider.nix
    ./ghostty.nix
    ./git.nix
    ./helix.nix
    ./tmux.nix
    ./zsh.nix
  ];

  options.profiles.development = with lib; {
    enable = mkEnableOption "development profile";
  };

  config = lib.mkIf cfg.enable {
    # Useful packages in development environments.
    home.packages = with pkgs; [
      curl
      dnsutils
      htop
      jq
      nix-prefetch-github
      nurl
      silver-searcher
      wget
      wireshark
      yq-go
      yubikey-manager

      # Kubernetes
      kubectl
      kubernetes-helm

      # Go
      go
      godef
      gopls

      # Gleam
      gleam
      erlang # erlang is needed to compile gleam
      elixir # for elixir dependencies
      rebar3 # sometimes also needed
    ];

    # Enable nh
    programs.nh.enable = true;

    home.sessionVariables = {
      LC_CTYPE = "en_US.UTF-8";
      GOPATH = "$HOME/go";
      EDITOR = "hx";
    };
  };
}
