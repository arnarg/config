{ config, lib, pkgs, ... }:
with lib; {
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
          # Flex key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVrnmUXJqts/422kHYm8TbatS6VT2iFAHiN8RxPBp3Q"
        ];
      };
    };

    groups = {
      arnar = {
        gid = 1000;
      };
    };
  };

  security.sudo.enable = true;

  time.timeZone = mkDefault "utc";
}
