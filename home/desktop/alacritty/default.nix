{ config, pkgs, ... }:
{
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding.x = 6;
          padding.y = 4;
          decorations = "None";
        };

        font = {
          size = 12;
          normal.family = "Inconsolata";
        };

        # One Dark
        colors = {
          primary = {
            background = "0x282c34";
            foreground = "0xabb2bf";
          };

          normal = {
            black = "0x282c34";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0xabb2bf";
          };

          bright = {
            black = "0x5c6370";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0xffffff";
          };
        };
      };
    };
  };
}
