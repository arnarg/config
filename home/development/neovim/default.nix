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

        # Autocomplete
        cmp-buffer
        cmp-path
        {
          plugin = cmp-nvim-lsp;
          config = ''
            lua <<EOF
            local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            require'lspconfig'.pyright.setup {
              capabilities = capabilities
            }
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

            cmp.setup({
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
            })
          EOF
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
        vim-gitgutter
        vim-nix
        vim-go
      ];
    };

  };
}
