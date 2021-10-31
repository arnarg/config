{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      whitesur-gtk-theme
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = ["user-theme@gnome-shell-extensions.gcampax.github.com" "dash-to-dock@micxgx.gmail.com"];
      };
      "org/gnome/desktop/interface" = {
        gtk-theme = "WhiteSur-dark";
        icon-theme = "WhiteSur-dark";
      };
      "org/gnome/desktop/wm/keybindings" = {
        minimize = [""];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        # Lock screen
        screensaver = ["<Super>q"];
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "alacritty";
        name = "Open Alacritty";
      };
    };
  };
}
