{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.desktop;

  # Get a wallpaper form wallhaven.
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/y8/wallhaven-y8jx3x.jpg";
    sha256 = "17hngmh4zixziipbjmrxs6mrl8465hlr23fwb745aknn53vhh63x";
  };
in {
  options.profiles.desktop.gnome = with lib; {
    enable = mkEnableOption "gnome integration";
    textScalingFactor = mkOption {
      type = types.float;
      default = 1.0;
      description = "Text scaling factor for Gnome.";
    };
    wallpaper = mkOption {
      type = types.package;
      default = wallpaper;
      description = "The wallpaper to use in Gnome.";
    };
    extensions.tailscale = {
      enable = mkEnableOption "tailscale extension";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.gnome.enable) {
    # Install various tools and extensions for gnome.
    home.packages = with pkgs;
      [
        gnome.gnome-tweaks
        gnomeExtensions.dash-to-dock
        gnomeExtensions.blur-my-shell
        (whitesur-icon-theme.override {
          boldPanelIcons = true;
          alternativeIcons = true;
          themeVariants = ["default"];
        })
      ]
      ++ (lib.optionals cfg.gnome.extensions.tailscale.enable [
        gnomeExtensions.tailscale-qs
      ]);

    programs.gnome-terminal = {
      enable = true;

      themeVariant = "dark";

      # My custom colorscheme for gnome terminal (copied from gruvbox dark)
      profile."56fdd740-fe3c-4add-89ad-a78feae91866" = {
        default = true;
        visibleName = "Gruvbox Dark";
        allowBold = true;
        font = "Inconsolata 12";

        colors = {
          backgroundColor = "#282828282828";
          foregroundColor = "#ebebdbdbb2b2";
          palette = [
            "#282828282828"
            "#cccc24241d1d"
            "#989897971a1a"
            "#d7d799992121"
            "#454585858888"
            "#b1b162628686"
            "#68689d9d6a6a"
            "#a8a899998484"
            "#929283837474"
            "#fbfb49493434"
            "#b8b8bbbb2626"
            "#fafabdbd2f2f"
            "#8383a5a59898"
            "#d3d386869b9b"
            "#8e8ec0c07c7c"
            "#ebebdbdbb2b2"
          ];
        };
      };
    };

    # Persisted dconf settings for gnome.
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions =
          [
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "dash-to-dock@micxgx.gmail.com"
            "blur-my-shell@aunetx"
          ]
          ++ (lib.optionals cfg.gnome.extensions.tailscale.enable [
            "tailscale@joaophi.github.com"
          ]);
      };
      "org/gnome/shell/keybindings" = {
        toggle-overview = ["<Primary>Up"];
      };
      "org/gnome/desktop/interface" = {
        icon-theme = "WhiteSur-dark";
        text-scaling-factor = cfg.gnome.textScalingFactor;
      };
      "org/gnome/desktop/wm/keybindings" = {
        minimize = [""];
        switch-input-source = ["<Super>t"];
        switch-input-source-backward = ["<Shift><Super>t"];
        switch-to-workspace-left = ["<Primary>Left" "<Super>h"];
        switch-to-workspace-right = ["<Primary>Right" "<Super>l"];
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,minimize,maximize:appmenu";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "${cfg.gnome.wallpaper}";
        picture-uri-dark = "${cfg.gnome.wallpaper}";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "${cfg.gnome.wallpaper}";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        # Lock screen
        screensaver = ["<Super>q"];
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      };
      ## Terminal stuff
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "gnome-terminal";
        name = "Open Terminal";
      };
      ## Dash-to-dock
      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = false;
        apply-glossy-effect = false;
        custom-background-color = true;
        transparency-mode = "FIXED";
        background-color = "rgb(36,31,49)";
        background-opacity = 0.65000000000000000;
        dash-max-icon-size = lib.mkDefault 68;
        dock-position = "BOTTOM";
        extend-height = false;
        running-indicator-style = "DOTS";
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = false;
      };
      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = false;
      };
    };
  };
}
