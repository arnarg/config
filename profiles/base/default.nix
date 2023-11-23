{lib, ...}:
with lib; {
  users = {
    users = {
      arnar = {
        isNormalUser = true;
        uid = 1000;
        group = "arnar";
        extraGroups = ["wheel"];
        home = "/home/arnar";
        openssh.authorizedKeys.keys = [
          # Flex key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVrnmUXJqts/422kHYm8TbatS6VT2iFAHiN8RxPBp3Q"
          # Framework key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHY8PNLd0CkdnUOLYw2jvCQzojThKXI8Y+mirYf2hq6g"
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

  services.avahi = {
    enable = lib.mkDefault true;
    nssmdns = true;
    ipv6 = false;
    publish.enable = true;
    publish.addresses = true;
    extraConfig = ''
      [publish]
      publish-aaaa-on-ipv4=no
    '';
  };

  nix = {
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    settings.trusted-users = ["root" "arnar"];
  };

  time.timeZone = mkDefault "utc";
}
