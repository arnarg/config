{
  pkgs,
  stable,
  ...
}: {
  imports = [
    ./firefox
  ];

  config = {
    home.packages = with pkgs; [
      wl-clipboard
      stable.spotify
    ];
  };
}
