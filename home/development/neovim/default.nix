{ config, lib, pkgs, ... }:
let
  cfg = config.local.neovim;
in with lib; {
  imports = [
    ./theme.nix
    ./lsp.nix
    ./go.nix
  ];

  config = {

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      inconsolata-nerdfont
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = ''
        " lets not use arrow keys
        noremap <Up> <NOP>
        noremap <Down> <NOP>
        noremap <Left> <NOP>
        noremap <Right> <NOP>
        inoremap <Up>    <NOP>
        inoremap <Down>  <NOP>
        inoremap <Left>  <NOP>
        inoremap <Right> <NOP>

        set cursorline

        autocmd BufNewFile,BufRead todo.txt set filetype=todotxt
      '';

      extraPackages = with pkgs; [
        curl
        gnutar
        ripgrep

        # For Treesitter
        gcc
      ] ++ optionals pkgs.stdenv.isLinux [
        wl-clipboard
      ];

      plugins = with pkgs.vimPlugins; mkBefore [
        # Which-key
        {
          plugin = which-key-nvim;
          type = "lua";
          config = ''
            local wk = require('which-key')

            wk.setup()
          '';
        }
        # Treesitter
        {
          plugin = nvim-treesitter;
          type = "lua";
          config = ''
            require('nvim-treesitter.configs').setup({
              ensure_installed = {
                "bash",
                "go",
                "python",
                "nix",
                "cpp",
                "c",
                "javascript",
                "markdown",
                "json",
                "yaml",
                "todotxt"
              },
              highlight = {
                  enable = true,
              }
            })
          '';
        }
        {
          plugin = nvim-treesitter-context;
          type = "lua";
          config = ''
            require('treesitter-context').setup()
          '';
        }
        {
          plugin = nvim-gps;
          type = "lua";
          config = ''
            require('nvim-gps').setup()
          '';
        }

        # Autocomplete
        cmp-buffer
        cmp-path
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            -- Setup nvim-cmp.
            local cmp = require('cmp')

            cmp.setup {
              preselect = cmp.PreselectMode.None,
              mapping = {
                ["<Tab>"] = function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                  else
                    fallback()
                  end
                end,
                ["<S-Tab>"] = function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                  else
                    fallback()
                  end
                end,
              },
              sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
              },
              formatting = {
                format = require'lspkind'.cmp_format {
                  with_text = true,
                  maxwidth = 50,
                }
              },
            }
          '';
        }

        # Telescope
        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            if wk ~= nil then
              wk.register({
                f = {
                  name = "Find",
                  f = { "<cmd>Telescope live_grep<cr>", "Find text" },
                  c = { "<cmd>Telescope git_commits<cr>", "Find commits" },
                },
                s = {
                  name = "Switch",
                  t = { "<cmd>Telescope filetypes<cr>", "Switch filetype" },
                }
              }, { prefix = '<leader>' })
            end
            vim.api.nvim_set_keymap('n', '<C-P>', '<cmd>Telescope find_files<cr>', { noremap = true })
          '';
        }

        # Dressing
        {
          plugin = dressing-nvim;
        }

        # Icon picker
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "icon-picker-nvim";
            version = "2022-07-17";
            src = pkgs.fetchFromGitHub {
              owner = "ziontee113";
              repo = "icon-picker.nvim";
              rev = "fddd49e084d67ed9b98e4c56b1a2afe6bf58f236";
              sha256 = "/4OeBu41PRW8hNI/166Y7Qv4OxmolBr/orarfXAw8mA=";
            };
          };
          type = "lua";
          config = ''
            require('icon-picker')
            if wk ~= nil then
              wk.register({
                ['<M-i>'] = { "<cmd>PickIconsInsert<cr>", "Insert emoji" },
              }, { mode = 'i' })
              wk.register({
                ['<M-i>'] = { "<cmd>PickIcons<cr>", "Insert emoji" },
              }, { mode = 'n' })
            end
          '';
        }

        # Commenting plugin
        {
          plugin = comment-nvim;
          type = "lua";
          config = ''
            require('Comment').setup()
          '';
        }

        # misc
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "tmux-navigate";
            version = "2020-05-06";
            src = pkgs.fetchFromGitHub {
              owner = "sunaku";
              repo = "tmux-navigate";
              rev = "52da3cdca6e23fda99e05527093d274622b742cd";
              sha256 = "0njnra2a9c51hxghhqlyvdi4b02wgmfd6jcpfhapcvvv599g8sri";
            };
          };
        }
        {
          plugin = numb-nvim;
          type = "lua";
          config = ''
            require('numb').setup()
          '';
        }
        editorconfig-nvim
        plenary-nvim
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''
            require('gitsigns').setup()
          '';
        }
        {
          plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "telekasten-nvim";
            version = "2022-05-20";
            src = pkgs.fetchFromGitHub {
              owner = "renerocksai";
              repo = "telekasten.nvim";
              rev = "0180e38eabc2f62748ea99730c4c26f5e4a9312a";
              sha256 = "qEAc40jpuG4RaBzOYUJHZsVRBVBXOoNIxxhDR9Y87u8=";
            };
          };
          type = "lua";
          config = ''
            local home = vim.fn.expand('~/Documents/notes')

            require('telekasten').setup({
              home = home,
              take_over_my_home = true,
              auto_set_filetype = true,
              templates = home .. '/' .. 'Templates',
              dailies = home .. '/' .. 'Daily',
              weeklies = home .. '/' .. 'Weekly',
              extension = ".md",
              dailies_create_nonexisting = false,
              weekly_create_nonexisting = false,
              follow_creates_nonexisting = true,
              template_new_note = nil,
              template_new_daily = nil,
              template_new_weekly = nil,
              image_link_style = "wiki",
              plug_into_calendar = false,
              tag_notation = "#tag",
              show_tags_theme = "dropdown",
              command_palette_theme = "dropdown",
            })

            if wk ~= nil then
              wk.register({
                n = {
                  name = 'Notes',
                  p = { '<cmd>Telekasten<cr>', 'Open command palette' },
                  f = { '<cmd>Telekasten find_notes<cr>', 'Find notes' },
                  s = { '<cmd>Telekasten search_notes<cr>', 'Search notes' },
                  n = { '<cmd>Telekasten new_templated_note<cr>', 'New Note' },
                  t = { '<cmd>Telekasten show_tags<cr>', 'Show tags' },
                },
              }, { prefix = '<leader>' })
            end
            vim.api.nvim_create_autocmd('FileType', {
              pattern = 'telekasten',
              callback = function()
                vim.api.nvim_command('nnoremap <buffer> f <cmd>Telekasten follow_link<cr>')
                vim.api.nvim_command('nnoremap <buffer> v <cmd>Telekasten show_backlinks<cr>')
              end,
            })
          '';
        }
        {
          plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "project-nvim";
            version = "2022-05-29";
            src = pkgs.fetchFromGitHub {
              owner = "ahmedkhalf";
              repo = "project.nvim";
              rev = "541115e762764bc44d7d3bf501b6e367842d3d4f";
              sha256 = "n5rbD0gBDsYSYvrjCDD1pWqS61c9/nRVEcyiVha0S20=";
            };
          };
          type = "lua";
          config = ''
            require("project_nvim").setup({
              detection_methods = { "lsp", "pattern" },
              patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
            })
            require('telescope').load_extension('projects')
            if wk ~= nil then
              wk.register({
                s = {
                  name = "Switch",
                  p = { '<cmd>Telescope projects<cr>', 'Switch project' },
                },
              }, { prefix = '<leader>' })
            end
          '';
        }

        # legacy vim plugins
        vim-nix

        # TODO-PROMPT
        {
          plugin = nui-nvim;
        }
        {
          plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "todotxt-nvim";
            version = "2022-02-08";
            src = pkgs.fetchFromGitHub {
              owner = "arnarg";
              repo = "todotxt.nvim";
              rev = "646198187f5d8bcf28b0cfa66f95d1aef165064a";
              sha256 = "5EZ430P3kmXV+xM+G0n0CyV2UtpOa2T3zTheVwTQ8Wo=";
            };
          };
          type = "lua";
          config = ''
            require('todotxt-nvim').setup({
              todo_file = "~/Documents/todo.txt",
            })

            if wk ~= nil then
              wk.register({
                t = {
                  name = 'Tasks',
                  t = { '<cmd>ToDoTxtTasksToggle<cr>', 'Toggle tasks pane' },
                  a = { '<cmd>ToDoTxtCapture<cr>', 'Capture task' },
                },
              }, { prefix = '<leader>' })
            end
            -- nnoremap <leader>a <cmd>ToDoTxtCapture<cr>
            -- nnoremap <leader>l <cmd>ToDoTxtTasksToggle<cr>
          '';
        }
      ];
    };

  };
}
