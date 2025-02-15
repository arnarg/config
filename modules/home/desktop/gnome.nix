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
    extensions.paperwm.winprops = mkOption {
      type = with types;
        attrsOf (submodule ({name, ...}: {
          options = {
            preferredWidth = mkOption {
              type = with types; nullOr str;
              default = null;
            };
            spaceIndex = mkOption {
              type = with types; nullOr int;
              default = null;
            };
          };
        }));
      default = {};
      apply = mapAttrsToList (n: v: {wm_class = n;} // (filterAttrs (_: opt: opt != null) v));
    };
  };

  config = lib.mkIf (cfg.enable && cfg.gnome.enable) {
    # Install various tools and extensions for gnome.
    home.packages = with pkgs;
      [
        gnome-tweaks
        gnomeExtensions.dash-to-dock
        gnomeExtensions.blur-my-shell
        gnomeExtensions.paperwm
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
            "paperwm@paperwm.github.com"
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
        command = "ghostty";
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
      ## PaperWM
      "org/gnome/shell/extensions/paperwm" = {
        default-focus-mode = 2;
        open-window-position = 0;
        horizontal-margin = 0;
        vertical-margin = 0;
        vertical-margin-bottom = 0;
        selection-border-size = 0;
        window-gap = 4;
        winprops = map builtins.toJSON cfg.gnome.extensions.paperwm.winprops;
      };
      "org/gnome/shell/extensions/paperwm/keybindings" = {
        move-down = ["<Control><Super>Down" "<Shift><Super>j"];
        move-up = ["<Control><Super>Up" "<Shift><Super>k"];
        move-left = ["<Control><Super>comma" "<Shift><Super>comma" "<Control><Super>Left" "<Shift><Super>h"];
        move-right = ["<Control><Super>period" "<Shift><Super>period" "<Control><Super>Right" "<Shift><Super>l"];
        move-down-workspace = ["<Shift><Control>j"];
        move-up-workspace = ["<Shift><Control>k"];
        switch-down = ["<Super>Down" "<Super>j"];
        switch-up = ["<Super>Up" "<Super>k"];
        switch-left = ["<Super>Left" "<Super>h"];
        switch-right = ["<Super>Right" "<Super>l"];
        switch-down-workspace = ["<Control><Super>j"];
        switch-up-workspace = ["<Control><Super>k"];
        switch-monitor-below = ["<Shift><Super>Down" "<Shift><Control><Super>j"];
        switch-monitor-above = ["<Shift><Super>Up" "<Shift><Control><Super>k"];
        switch-monitor-left = ["<Shift><Super>Left" "<Shift><Control><Super>h"];
        switch-monitor-right = ["<Shift><Super>Right" "<Shift><Control><Super>l"];
        move-space-monitor-below = ["<Shift><Control><Alt>Down" "<Shift><Control><Alt>j"];
        move-space-monitor-above = ["<Shift><Control><Alt>Up" "<Shift><Control><Alt>k"];
        move-space-monitor-left = ["<Shift><Control><Alt>Left" "<Shift><Control><Alt>l"];
        move-space-monitor-right = ["<Shift><Control><Alt>Right" "<Shift><Control><Alt>h"];
        # Unbind take-window
        take-window = [""];
        # new-window overrides <Super>Enter by default
        new-window = ["<Super>n"];
      };
    };

    # Set paperwm winprops
    profiles.desktop.gnome.extensions.paperwm.winprops = {
      firefox = {
        spaceIndex = 0;
      };
    };
  };
}
