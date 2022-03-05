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
          local gps = require("nvim-gps")
          require('lualine').setup {
            options = {
              icons_enabled = true,
              theme = "gruvbox",
            },
            sections = {
              lualine_c = {
                "filename",
                { gps.get_location, cond = gps.is_available },
              }
            }
          }
          END
        '';
      }
      {
        plugin = vim-numbertoggle;
        config = "set nu rnu";
      }
      {
        plugin = nvim-tree-lua;
        config = ''
          let g:nvim_tree_quit_on_open = 1
          lua require'nvim-tree'.setup()
          nnoremap <C-n> :NvimTreeToggle<CR>
        '';
      }
      {
        plugin = bufferline-nvim;
        config = ''
          nnoremap <leader>. :BufferLineCycleNext<CR>
          nnoremap <leader>, :BufferLineCyclePrev<CR>
          nnoremap <leader>> :BufferLineMoveNext<CR>
          nnoremap <leader>< :BufferLineMovePrev<CR>
          nnoremap <leader>p :BufferLinePick<CR>
          nnoremap <leader>qp :BufferLinePickClose<CR>
          nnoremap <leader>ql :BufferLineCloseLeft<CR>
          nnoremap <leader>qr :BufferLineCloseRight<CR>
          lua <<EOF
          require('bufferline').setup {
            options = {
              show_buffer_close_icons = false,
              show_close_icon = false,
              offsets = {
                {
                  filetype = "NvimTree",
                  text = "File Explorer",
                  highlight = "Directory",
                  text_align = "left"
                }
              }
            }
          }
          EOF
        '';
      }
      {
        plugin = nvim-notify;
        config = ''
          lua <<EOF
          require('notify').setup({
            stages = "static",
          })
          require('telescope').load_extension('notify')
          vim.notify = require('notify')
          EOF
        '';
      }
    ];
  };
}
