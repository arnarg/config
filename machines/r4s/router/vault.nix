{
  config,
  lib,
  pkgs,
  ...
}: {
  services.vault = {
    enable = true;
    storageBackend = "file";
    storagePath = "/nix/persist/var/lib/vault";
  };
}
