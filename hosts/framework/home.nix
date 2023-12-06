{inputs, ...}: {
  imports = [
    "${inputs.self}/home/desktop/gnome"
    "${inputs.self}/home/desktop/tpm-fido"
  ];

  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
