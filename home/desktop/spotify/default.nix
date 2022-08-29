{
  config,
  pkgs,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      spotifyd
      spotify-tui
    ];
  };
}
