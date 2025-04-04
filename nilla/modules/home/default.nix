{
  imports = [
    ./desktop
    ./development
  ];

  home.stateVersion = "24.11";

  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
