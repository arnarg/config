{pkgs, ...}: {
  imports = [
    ./firefox
  ];

  config = {
    home.packages = with pkgs; [
      wl-clipboard
      spotify
    ];
  };
}
