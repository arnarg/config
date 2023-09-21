{
  config,
  pkgs,
  ...
}: {
  config = {
    # This needs to be set in order for firefox to build
    home.stateVersion = "21.05";

    programs.firefox.enable = true;

    programs.firefox.profiles.default.id = 0;
    programs.firefox.profiles.default.isDefault = true;
    programs.firefox.profiles.default.settings = {
      # It keeps asking me on startup if I want firefox as default
      "browser.shell.checkDefaultBrowser" = false;
      # Disable pocket
      "extensions.pocket.enable" = false;
      # Disable firefox reacting to media keys
      "media.hardwaremediakeys.enabled" = false;
      # Enale userContent loading
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
    programs.firefox.profiles.default.userContent = ''
      /* Workaround for vim-vixen issue
       * https://github.com/ueokande/vim-vixen/issues/1424
       */
      .vimvixen-console-frame {
        height: 0px;
        color-scheme: light !important;
      }
    '';
  };
}
