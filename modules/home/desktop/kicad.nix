{pkgs, ...}: let
  kicadThemes = pkgs.fetchFromGitHub {
    owner = "pointhi";
    repo = "kicad-color-schemes";
    rev = "2021-12-05";
    hash = "sha256-PYgFOyK5MyDE1vTkz5jGnPWAz0pwo6Khu91ANgJ2OO4=";
  };
in {
  home.packages = with pkgs; [
    kicad-small
  ];

  # Add behave dark theme
  xdg.configFile."kicad/7.0/colors/behave-dark.json" = {
    source = "${kicadThemes}/behave-dark/behave-dark.json";
  };
}
