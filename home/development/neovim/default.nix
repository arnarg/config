{ config, lib, pkgs, ... }:
let
  cfg = config.local.neovim;
in with lib; {
  imports = [
    ./theme.nix
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
      '';

      extraPackages = with pkgs; [
        curl
        gnutar
        ripgrep

        # For Treesitter
        gcc

        # For LSP
        pyright
        gopls
        rnix-lsp
      ] ++ optionals pkgs.stdenv.isLinux [
        wl-clipboard
      ];

      plugins = with pkgs.vimPlugins; [
        # Treesitter
        {
          plugin = nvim-treesitter;
          config = ''
            lua <<EOF
            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            parser_config.todotxt = {
              install_info = {
                url = "https://github.com/arnarg/tree-sitter-todotxt.git",
                files = {"src/parser.c"},
                branch = "main",
              },
              filetype = "todotxt",
            }
            require('nvim-treesitter.configs').setup {
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
            }
            EOF
            autocmd BufNewFile,BufRead todo.txt set filetype=todotxt
          '';
        }
        {
          plugin = nvim-treesitter-context;
          config = "lua require'treesitter-context'.setup()";
        }
        {
          plugin = nvim-gps;
          config = "lua require'nvim-gps'.setup()";
        }

        # LSP
        nvim-lspconfig
        lspkind-nvim

        # Telescope
        {
          plugin = telescope-nvim;
          config = ''
            nnoremap <C-P> <cmd>Telescope find_files<cr>
            nnoremap <leader>f <cmd>Telescope live_grep<cr>
            nnoremap <leader>c <cmd>Telescope git_commits<cr>
            nnoremap <leader>t <cmd>Telescope filetypes<cr>
          '';
        }

        # Autocomplete
        cmp-buffer
        cmp-path
        {
          plugin = cmp-nvim-lsp;
          config = ''
            lua <<EOF
            local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            -- require'lspconfig'.pyright.setup {
            --   capabilities = capabilities
            -- }
            require'lspconfig'.gopls.setup {
              capabilities = capabilities
            }
            require'lspconfig'.rnix.setup {
              capabilities = capabilities
            }
            EOF
          '';
        }
        {
          plugin = nvim-cmp;
          config = ''
            lua <<EOF
            -- Setup nvim-cmp.
            local cmp = require'cmp'

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
          EOF
          '';
        }

        # Commenting plugin
        {
          plugin = comment-nvim;
          config = ''
            lua require('Comment').setup()
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
          plugin = which-key-nvim;
          config = "lua require'which-key'.setup()";
        }
        {
          plugin = toggleterm-nvim;
          config = ''
            lua <<EOF
            require'toggleterm'.setup({
              start_in_insert = false,
              direction = 'vertical',
              size = 70,
            })
            function _G.set_terminal_keymaps()
              local opts = {noremap = true}
              vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
            end
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
            EOF
            nnoremap <leader>T <cmd>ToggleTerm<cr>
          '';
        }
        {
          plugin = numb-nvim;
          config = ''
            lua require('numb').setup()
          '';
        }
        editorconfig-nvim
        plenary-nvim
        {
          plugin = gitsigns-nvim;
          config = ''
            lua require('gitsigns').setup()
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
          config = ''
            lua <<EOF
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
            EOF
            nnoremap <leader>zz <cmd>Telekasten<cr>
            nnoremap <leader>zf <cmd>Telekasten find_notes<cr>
            nnoremap <leader>zs <cmd>Telekasten search_notes<cr>
            nnoremap <leader>zn <cmd>Telekasten new_templated_note<cr>
            nnoremap <leader>zt <cmd>Telekasten show_tags<cr>
            autocmd FileType telekasten nnoremap <buffer> f <cmd>Telekasten follow_link<cr>
            autocmd FileType telekasten nnoremap <buffer> v <cmd>Telekasten show_backlinks<cr>
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
          config = ''
          lua << EOF
          require("project_nvim").setup({
            detection_methods = { "lsp", "pattern" },
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
          })
          require('telescope').load_extension('projects')
          EOF
          '';
        }

        # legacy vim plugins
        vim-nix
        vim-go

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
          config = ''
            lua <<EOF
            require('todotxt-nvim').setup({
              todo_file = "~/Documents/todo.txt",
            })
            EOF
            nnoremap <leader>a <cmd>ToDoTxtCapture<cr>
            nnoremap <leader>l <cmd>ToDoTxtTasksToggle<cr>
          '';
        }
      ];
    };

  };
}
