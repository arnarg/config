{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./interfaces.nix
  ];

  config = {
    # Setup server profile.
    profiles.server.enable = true;

    # Setup immutable profile.
    profiles.immutable.enable = true;
    profiles.immutable.directories = [
      "/var/lib/tailscale"
      "/var/lib/private/lldap"
      "/var/lib/authelia-main"
    ];

    ################
    ## Bootloader ##
    ################
    # According to https://nixos.wiki/wiki/NixOS_on_ARM/UEFI
    boot.loader.efi.canTouchEfiVariables = false;
    boot.loader.systemd-boot.enable = true;
    boot.loader.timeout = 2;

    # Run latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    ################
    ## Networking ##
    ################
    networking.useDHCP = false;
    networking.interfaces.wan0.useDHCP = true;

    ###############
    ## Tailscale ##
    ###############
    services.tailscale.enable = true;

    #################
    ## LDAP Server ##
    #################
    services.lldap.enable = true;
    services.lldap.settings = {
      ldap_base_dn = "dc=cdbrdr,dc=com";
    };

    # ##################
    # ## Authelia SSO ##
    # ##################
    services.authelia.instances.main = {
      enable = true;
      settings = {
        theme = "light";
        default_2fa_method = "totp";
        log.level = "debug";
        access_control.default_policy = "two_factor";
        session.domain = "localhost";
        storage.local.path = "/var/lib/authelia-main/db.sqlite3";
        notifier.filesystem.filename = "/var/lib/authelia-main/notifications.txt";
        authentication_backend = {
          password_reset.disable = false;
          refresh_interval = "1m";
          ldap = {
            url = "ldap://127.0.0.1:3890";
            implementation = "custom";
            start_tls = false;
            base_dn = "dc=cdbrdr,dc=com";
            additional_users_dn = "ou=people";
            users_filter = "(&({username_attribute}={input})(objectClass=person))";
            additional_groups_dn = "ou=groups";
            groups_filter = "(member={dn})";
            display_name_attribute = "displayName";
            username_attribute = "uid";
            group_name_attribute = "cn";
            mail_attribute = "mail";
            user = "uid=authelia,ou=people,dc=cdbrdr,dc=com";
          };
        };
      };
      # Use systemd's LoadCredential instead
      secrets.manual = true;
    };
    systemd.services.authelia-main = {
      environment = {
        AUTHELIA_JWT_SECRET_FILE = "%d/jwt_secret";
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "%d/encryption_key";
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = "%d/ldap_password";
      };
      serviceConfig.LoadCredential = [
        "jwt_secret:/nix/persist/etc/authelia/jwt_secret"
        "encryption_key:/nix/persist/etc/authelia/encryption_key"
        "ldap_password:/nix/persist/etc/authelia/ldap_password"
      ];
    };

    ##########
    ## Sudo ##
    ##########
    # So I can use nixos-rebuild with --use-remote-sudo
    # TODO: Figure out how to allow less commands
    security.sudo.extraRules = [
      {
        users = ["arnar"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    #################
    ## NixOS stuff ##
    #################
    system.stateVersion = "23.11";
    nix.gc = {
      automatic = true;
      dates = "*-*-* 00:00:00";
      options = "--delete-older-than 7d";
    };
  };
}
