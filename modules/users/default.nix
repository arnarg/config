{ pkgs, ... }:

{
  users = {
    users = {
      arnar = {
        isNormalUser = true;
        uid = 1000;
        group = "arnar";
        extraGroups = [ "wheel" ];
        home = "/home/arnar";
        openssh.authorizedKeys.keys = [
          # Yubikey 1
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCJgc736QyZbRlQLbK8Lm8Ra8EJdZIl3U84DRP3U7qmR/jSQR9P92RBuIXWTbcHbNxeZbMx7g6n9CDDPV0weXRQ="
          # Yubikey 2
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDKo0cPCEyU0wpsxTlKLqlLqjbO491aF80OE86lepqbrZpWqNurFd8EUdisSyOG5fMNNlbS3H7lVOruqGbuJUYo="
        ];
        packages = with pkgs; [
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
        ];
      };
    };

    groups = {
      arnar = {
        gid = 1000;
      };
    };
  };
  local.immutable.users = [ "arnar" ];
}
