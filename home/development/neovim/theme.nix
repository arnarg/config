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
        type = "lua";
        config = ''
          require('nvim-web-devicons').setup()
        '';
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          local gps = require('nvim-gps')
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
        '';
      }
      {
        plugin = vim-numbertoggle;
        config = "set nu rnu";
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require('nvim-tree').setup({
            update_cwd = true,
            respect_buf_cwd = true,
            actions = {
              open_file = {
                quit_on_open = true,
              },
            },
          })

          vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<cr>', { noremap = true })
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require('bufferline').setup({
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
          })

          if wk ~= nil then
            wk.register({
              b = {
                name = 'Buffer',
                p = { '<cmd>BufferLinePick<cr>', 'Pick buffer' },
                q = {
                  name = 'Close Buffer',
                  p = { '<cmd>BufferLinePickClose<cr>', 'Pick buffer to close' },
                  l = { '<cmd>BufferLineCloseLeft<cr>', 'Close all buffers to the left' },
                  r = { '<cmd>BufferLineCloseRight<cr>', 'Close all buffers to the right' },
                },
                ['>'] = { '<cmd>BufferLineMoveNext<cr>', 'Move buffer to the right' },
                ['<'] = { '<cmd>BufferLineMovePrev<cr>', 'Move buffer to the left' },
              },
              ['.'] = { '<cmd>BufferLineCycleNext<cr>', 'Switch to next buffer' },
              [','] = { '<cmd>BufferLineCyclePrev<cr>', 'Switch to previous buffer' },
            }, { prefix = '<leader>' })
          end
        '';
      }
      {
        plugin = nvim-notify;
        type = "lua";
        config = ''
          require('notify').setup({
            stages = "static",
          })
          require('telescope').load_extension('notify')
          vim.notify = require('notify')
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
        type = "lua";
        config = ''
          require("scrollbar").setup()
        '';
      }
    ];
  };
}
