{
  pkgs,
  ...
}: {
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
      timewarrior
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
    ];

    home.sessionVariables = {
      LC_CTYPE = "en_US.UTF-8";
      GOPATH = "$HOME/go";
      TIMEWARRIORDB = "$HOME/.local/share/timewarrior";
    };

    # Task manager
    programs.taskwarrior.enable = true;
  };
}
