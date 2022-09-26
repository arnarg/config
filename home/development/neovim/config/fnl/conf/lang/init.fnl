(import-macros {: setup!} :lib.macros)
(import-macros {: command!} :hibiscus.vim)

(local create_augroup vim.api.nvim_create_augroup)
(local create_autocmd vim.api.nvim_create_autocmd)

;; go-nvim
(local go (require :go))
(local gofmt (require :go.format))
(setup! go {:textobjects false})

(local gogroup (create_augroup :go {:clear true}))
(create_autocmd [:BufWritePre] {:pattern [:*.go]
                                :callback (fn []
                                            (gofmt.goimport))
                                :group gogroup})

;; fennel
(local fnlgroup (create_augroup :fennel {:clear true}))
(create_autocmd [:FileType] {:pattern :fennel
                             :command "setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab"
                             :group fnlgroup})

