self: super: {

  # I need to enable ui scaling on my workstation
  spotify = super.spotify.overrideAttrs (oa: rec {
    postInstall = ''
      echo "Patch spotify.desktop to enable UI scaling"
      sed -i "s|^Exec=spotify|Exec=spotify --force-device-scale-factor=1.5|" "$out/share/applications/spotify.desktop"
    '';
  });

}
