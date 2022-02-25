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
              mapping = {
                ["<Tab>"] = function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end,
                ["<S-Tab>"] = function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
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
          plugin = git-blame-nvim;
          config = ''
            let g:gitblame_enabled = 0
            nnoremap <leader>b <cmd>GitBlameToggle<cr>
          '';
        }
        {
          plugin = which-key-nvim;
          config = "lua require'which-key'.setup()";
        }
        {
          plugin = toggleterm-nvim;
          config = ''
            lua <<EOF
            require'toggleterm'.setup()
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
        vim-gitgutter
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
              rev = "fb060ea98e4957e670eb031254d57932242fa8e6";
              sha256 = "R5czsM7Dykz03OOaoyjFhvq0rJyUe0aS/BDF+h5FMik=";
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
