{pkgs, ...}: {
  # Setup desktop profile.
  profiles.desktop.enable = true;
  profiles.desktop.gnome.enable = true;

  # Setup development profile.
  profiles.development.enable = true;
  profiles.development.radicle.enable = true;

  # Extra packages needed on this host only.
  home.packages = with pkgs; [
    terraform
    terragrunt
    awscli
  ];

  # Load work git config.
  programs.git.includes = [
    {
      condition = "gitdir:~/Code/work/";
      path = "~/Code/work/.gitconfig";
    }
    {
      condition = "gitdir:~/Code/bnt/";
      path = "~/Code/bnt/.gitconfig";
    }
  ];

  # Set smaller icon size in dock.
  dconf.settings."org/gnome/shell/extensions/dash-to-dock".dash-max-icon-size = 54;
  # Enable fractional scaling.
  dconf.settings."org/gnome/mutter".experimental-features = ["scale-monitor-framebuffer"];
}
