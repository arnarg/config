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
    crush
    inputs.nilla-cli.result.packages.nilla-cli.result.x86_64-linux
    inputs.nilla-utils.result.packages.nilla-utils-plugins.result.x86_64-linux
  ];

  # Prefer internal differ in nilla-utils
  home.sessionVariables.NILLA_UTILS_DIFF = "internal";
}
