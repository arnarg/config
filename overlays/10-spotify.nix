{ config, ... }:
self: super: {

  # I need to enable ui scaling on my workstation
  spotify = if config.local.displayScalingFactor > 1 then super.spotify.overrideAttrs (oa: rec {
    postInstall = ''
      echo "Patch spotify.desktop to enable UI scaling"
      sed -i "s|^Exec=spotify|Exec=spotify --force-device-scale-factor=${builtins.toString config.local.displayScalingFactor}|" "$out/share/applications/spotify.desktop"
    '';
  }) else super.spotify;

}
