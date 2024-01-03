{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.desktop;
in {
  imports = [
    ./gnome.nix
    ./tpm-fido.nix
  ];

  options.profiles.desktop = with lib; {
    enable = mkEnableOption "desktop profile";
  };

  config = lib.mkIf cfg.enable {
    # Useful packages in desktop environments.
    home.packages = with pkgs; [
      wl-clipboard
      spotify
      kicad-small
    ];

    # Setup firefox.
    programs.firefox = {
      enable = true;
      profiles.default.id = 0;
      profiles.default.isDefault = true;
      profiles.default.settings = {
        # It keeps asking me on startup if I want firefox as default
        "browser.shell.checkDefaultBrowser" = false;
        # Disable pocket
        "extensions.pocket.enable" = false;
        # Disable firefox reacting to media keys
        "media.hardwaremediakeys.enabled" = false;
        # Enale userContent loading
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      profiles.default.userContent = ''
        /* Workaround for vim-vixen issue
         * https://github.com/ueokande/vim-vixen/issues/1424
         */
        .vimvixen-console-frame {
          height: 0px;
          color-scheme: light !important;
        }
      '';
    };
  };
}
