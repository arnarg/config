(import-macros {: setup!} :lib.macros)

(local create_augroup vim.api.nvim_create_augroup)
(local create_autocmd vim.api.nvim_create_autocmd)

(local formatter (require :formatter))
(local {: stylua} (require :formatter.filetypes.lua))
(local {: black} (require :formatter.filetypes.python))
(local {:prettier prettierjs} (require :formatter.filetypes.javascript))
(local {:prettier prettierts} (require :formatter.filetypes.typescript))

(setup! formatter
        {:filetype {:lua stylua
                    :python black
                    :javascript prettierjs
                    :typescript prettierts
                    :fennel (fn []
                              {:exe :fnlfmt :args ["-"] :stdin true})
                    :nix (fn []
                           {:exe :alejandra :args ["-"] :stdin true})
                    :terraform (fn []
                                 {:exe :terraform :args [:fmt "-"] :stdin true})
                    :hcl (fn []
                           {:exe :hclfmt :stdin true})}})

(local fmtgroup (create_augroup :FormatAutogroup {:clear true}))
(create_autocmd [:BufWritePost]
                {:pattern ["*"] :command :FormatWrite :group fmtgroup})

