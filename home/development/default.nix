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
      python3
      silver-searcher
      timewarrior
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
      TIMEWARRIORDB = "$HOME/.local/share/timewarrior";
    };

    # Task manager
    programs.taskwarrior.enable = true;
  };
}
