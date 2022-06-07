{ config, lib, pkgs, ... }:
let
  cfg = config.local.neovim;
in with lib; {
  imports = [
    ./theme.nix
  ];

  config = {
    programs.neovim = {
      extraPackages = with pkgs; [
        go
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "go-nvim";
            version = "2022-06-03";
            src = pkgs.fetchFromGitHub {
              owner = "ray-x";
              repo = "go.nvim";
              rev = "b22f8c7760727d8acace61711a9f095142e87099";
              sha256 = "iqVG4zrrnoFe0mNbhKTREM3CvjODUsmgrSRyXjingjY=";
            };
          };
          type = "lua";
          config = ''
            require('go').setup()
          '';
        }
      ];
    };
  };
}
