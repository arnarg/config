{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./profiles/desktop.nix
    ./profiles/development.nix
    ./profiles/immutable.nix
    ./profiles/laptop.nix
    ./profiles/server.nix
    ./profiles/tpm.nix
  ];

  config = {
    # All systems will get this user.
    users = {
      users.arnar = {
        isNormalUser = true;
        uid = 1000;
        group = "arnar";
        extraGroups = ["wheel"];
        home = "/home/arnar";
        openssh.authorizedKeys.keys = [
          # Framework key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHY8PNLd0CkdnUOLYw2jvCQzojThKXI8Y+mirYf2hq6g"
        ];
      };

      groups.arnar = {
        gid = 1000;
      };
    };

    # Default timezone should be UTC.
    time.timeZone = lib.mkDefault "utc";

    # All systems should have sudo.
    security.sudo.enable = true;

    # Setup nix config for all systems.
    nix = {
      extraOptions = "extra-experimental-features = nix-command flakes";
      # generateNixPathFromInputs = true;
      # generateRegistryFromInputs = true;
      # linkInputs = true;
      settings.trusted-users = ["root" "arnar"];
      package = pkgs.lix;
    };

    # Setup persistence paths.
    profiles.immutable.files = [
      "/etc/machine-id"
    ];

    profiles.immutable.directories = [
      "/var/lib/nixos"
    ];

    # Set nixpkgs in registry.json
    nix.registry.nixpkgs = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      to = {
        type = "path";
        path = inputs.nixpkgs.src;
      };
    };

    # Set NIX_PATH to /etc/nix/inputs and create those symlinks
    nix.nixPath = ["/etc/nix/inputs"];
    environment.etc = builtins.listToAttrs (lib.mapAttrsToList (n: val: {
        name = "nix/inputs/${n}";
        value.source = val.src;
      })
      inputs);
  };
}
