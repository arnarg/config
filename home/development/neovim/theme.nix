{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    extraConfig = ''
      set termguicolors
      set background=dark
      set laststatus=3
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
          lua <<EOF
          require('nvim-tree').setup({
            actions = {
              open_file = {
                quit_on_open = true,
              },
            },
          })
          EOF
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
      {
        plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-scrollbar";
          version = "2022-02-26";
          src = pkgs.fetchFromGitHub {
            owner = "petertriho";
            repo = "nvim-scrollbar";
            rev = "b10ece8f991e2c096bc2a6a92da2a635f9298d26";
            sha256 = "0IwTzVgYi2Z7M2+vJuP+lrKVrTOBWdrIi3mtsj0E+wg=";
          };
        };
        config = ''
          lua require("scrollbar").setup()
        '';
      }
    ];
  };
}
