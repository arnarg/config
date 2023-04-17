{pkgs, ...}: {
  imports = [
    ./firefox
  ];

  config = {
    home.packages = with pkgs; [
      mailspring
      wl-clipboard
    ];
  };
}
