{ pkgs }:
with pkgs; [
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
  mypkgs.mkosi

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
