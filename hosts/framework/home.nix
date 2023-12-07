{...}: {
  # Setup desktop profile.
  profiles.desktop.enable = true;
  profiles.desktop.gnome.enable = true;
  profiles.desktop.tpm-fido.enable = true;

  # Setup development profile.
  profiles.development.enable = true;
}
