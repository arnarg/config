{
  pkgs,
  inputs,
  ...
}: {
  # Setup desktop profile.
  profiles.desktop.enable = true;
  profiles.desktop.tpm-fido.enable = true;
  profiles.desktop.gnome.enable = true;
  profiles.desktop.gnome.extensions.tailscale.enable = true;
  # Framework has a pretty high DPI display.
  profiles.desktop.gnome.textScalingFactor = 1.2;

  # Setup development profile.
  profiles.development.enable = true;

  home.packages = with pkgs; [
    ente-desktop
    ente-auth
    argocd
    npins
    inputs.lila.result.packages.default.result.x86_64-linux
  ];
}
