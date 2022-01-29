{ config, lib, pkgs, ... }:
with lib; {
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

      #extraConfig = builtins.readFile ./init.vim;
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

        # For LSP
        gcc
        pyright
        gopls
      ];

      # WIP re-implementing my vim setup
      plugins = with pkgs.vimPlugins; [
        # Treesitter
        nvim-treesitter
        {
          plugin = nvim-treesitter-context;
          config = "lua require'treesitter-context'.setup()";
        }

        # LSP
        {
          plugin = nvim-lspconfig;
          config = ''
            lua require'lspconfig'.pyright.setup{}
            lua require'lspconfig'.gopls.setup{}
          '';
        }

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

        # NvimTree
        {
          plugin = nvim-tree-lua;
          config = ''
            let g:nvim_tree_quit_on_open = 1
            lua require'nvim-tree'.setup()
            nnoremap <C-n> :NvimTreeToggle<CR>
          '';
        }

        # Autocomplete
        {
          plugin = nvim-cmp;
          config = ''
            lua <<EOF
            -- Setup nvim-cmp.
            local cmp = require'cmp'

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
              sources = {
                { name = 'buffer' }
              }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
              sources = cmp.config.sources({
                { name = 'path' }
              }, {
                { name = 'cmdline' }
              })
            })

            -- Setup lspconfig.
            local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            require('lspconfig')['gopls'].setup {
              capabilities = capabilities
            }
          EOF
          '';
        }
        cmp-nvim-lsp

        # misc
        {
          plugin = pkgs.vimUtils.buildVimPlugin rec {
            pname = "bufstop";
            version = "1.6.2";
            src = pkgs.fetchFromGitHub {
              owner = "mihaifm";
              repo = "bufstop";
              rev = version;
              sha256 = "hWzJWMvfnfweRLTsWYZBIbuCm7rMLYIp0kQrN68oX+A=";
            };
          };
          config = ''
            nnoremap <leader>, :BufstopBack<CR>
            nnoremap <leader>. :BufstopForward<CR>
          '';
        }
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
        vim-gitgutter
        vim-nix
        vim-go
      ];
    };

  };
}
