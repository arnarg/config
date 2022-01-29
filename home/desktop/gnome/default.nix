{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      whitesur-gtk-theme
      whitesur-icon-theme
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "dash-to-dock@micxgx.gmail.com"
          "blur-my-shell@aunetx"
        ];
      };
      "org/gnome/shell/keybindings" = {
        toggle-overview = ["<Primary>Up"];
      };
      "org/gnome/desktop/interface" = {
        gtk-theme = "WhiteSur-dark";
        icon-theme = "WhiteSur-dark";
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "WhiteSur-dark";
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
        picture-uri = "${pkgs.whitesur-gtk-theme}/share/wallpapers/WhiteSur-light.png";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "${pkgs.whitesur-gtk-theme}/share/wallpapers/WhiteSur-light.png";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        # Lock screen
        screensaver = ["<Super>q"];
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "gnome-terminal";
        name = "Open Terminal";
      };
      "org/gnome/terminal/legacy" = {
        theme-variant = "dark";
      };
      "org/gnome/terminal/legacy/profiles:/:e3d42099-782a-4d98-9f75-56db9e230c6a" = {
        visible-name = "Gruvbox Dark";
        allow-bold = true;
        background-color = "#282828282828";
        bold-color = "#ebebdbdbb2b2";
        bold-color-same-as-fg = true;
        cursor-background-color = "#ebebdbdbb2b2";
        cursor-colors-set = true;
        cursor-foreground-color = "#282828282828";
        font = "Inconsolata for Powerline Medium 12";
        foreground-color = "#ebebdbdbb2b2";
        use-system-font = false;
        use-theme-background = false;
        use-theme-colors = false;
        use-theme-transparency = false;
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
}
