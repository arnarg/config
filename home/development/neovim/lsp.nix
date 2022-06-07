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
        gopls
        pyright
        rnix-lsp
        rust-analyzer
      ];

      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        lspkind-nvim
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

            local opts = { noremap=true, silent=true }
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

            local on_attach = function(client, bufnr)
              -- Enable completion triggered by <c-x><c-o>
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

              if wk ~= nil then
                wk.register({
                  K = { vim.lsp.buf.hover, 'Show signature' },
                  g = {
                    D = { vim.lsp.buf.declaration, 'Go to declaration' },
                    d = { vim.lsp.buf.definition, 'Go to definition' },
                    i = { vim.lsp.buf.implementation, 'Go to implementation' },
                    r = { vim.lsp.buf.references, 'Go to references' },
                  },
                  ['<space>'] = {
                    w = {
                      name = "Workspace folders",
                      a = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
                      r = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
                      l = { function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                      end, 'List workspace folders' },
                    },
                    D = { vim.lsp.buf.type_definition, 'Show type definition' },
                    ['rn'] = { vim.lsp.buf.rename, 'Rename' },
                    ['ca'] = { vim.lsp.buf.code_action, 'Code action' },
                    f = { vim.lsp.buf.formatting, 'Formatting' },
                  },
                }, { noremap = true, silent = true, buffer = bufnr })
              else
                local bufopts = { noremap=true, silent=true, buffer=bufnr }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                vim.keymap.set('n', '<space>wl', function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
                vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
              end
            end

            local servers = {
              'gopls',
              'rust_analyzer',
              'rnix'
            }
            for _, lsp in pairs(servers) do
              require('lspconfig')[lsp].setup {
                on_attach = on_attach,
                capabilities = capabilities,
              }
            end
          '';
        }
      ];
    };
  };
}
