{ config, pkgs, ... }:
{
  config = {
    dconf.settings = {
      #"org/gnome/shell" = {
      #  enabled-extensions = ["material-shell@papyelgringo"];
      #};
      #"org/gnome/shell/extensions/materialshell/bindings" = {
      #  kill-focused-window = ["<Shift><Super>q"];
      #  move-window-bottom = ["<Shift><Super>j"];
      #  move-window-left = ["<Shift><Super>h"];
      #  move-window-right = ["<Shift><Super>l"];
      #  move-window-top = ["<Shift><Super>k"];
      #  next-window = ["<Super>l" "<Super>d"];
      #  next-workspace = ["<Super>j" "<Super>s"];
      #  previous-window = ["<Super>h" "<Super>a"];
      #  previous-workspace = ["<Super>k" "<Super>w"];
      #};
      "org/gnome/desktop/interface" = {
        gtk-theme = "Plata-Compact";
        icon-theme = "Tela";
      };
      "org/gnome/mutter" = {
        # My laptop doesn't even have a right super key
        # I just don't want the annoying overlay to show up when
        # I press the super key
        overlay-key = "Super_R";
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
