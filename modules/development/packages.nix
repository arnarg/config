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

  # Go
  go
  gocode
  godef

  # Kubernetes
  #kubectl
  #kubectx
  #kubernetes-helm
  #mypkgs.operator-sdk
  #mypkgs.ksniff
]
