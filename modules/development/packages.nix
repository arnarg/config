{ pkgs }:
with pkgs; [
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
  mypkgs.pushnix

  # Go
  go
  gocode
  godef

  # Kubernetes
  #kubectl
  #kubectx
  #kubernetes-helm
  #operator-sdk
  #mypkgs.ksniff
]
