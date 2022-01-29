{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    extraConfig = ''
      set termguicolors
      set background=dark
    '';

    plugins = with pkgs.vimPlugins; [
      lush-nvim
      indent-blankline-nvim-lua
      {
        plugin = nvim-web-devicons;
        config = ''
          lua require'nvim-web-devicons'.setup()
        '';
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      {
        plugin = lualine-nvim;
        config = ''
          lua << END
          require('lualine').setup {
            options = {
              icons_enabled = true,
              theme = "gruvbox",
            }
          }
          END
        '';
      }
      {
        plugin = neoscroll-nvim;
        config = "lua require('neoscroll').setup()";
      }
      {
        plugin = vim-numbertoggle;
        config = "set nu rnu";
      }
    ];
  };
}
