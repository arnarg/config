(local create_augroup vim.api.nvim_create_augroup)
(local create_autocmd vim.api.nvim_create_autocmd)

;; go-nvim
(local go (require :go))
(local gofmt (require :go.format))
(go.setup)

(local gogroup (create_augroup :go {:clear true}))
(create_autocmd [:BufWritePre]
                {:pattern ["*.go"]
		 :callback (fn [] (gofmt.goimport))
		 :group gogroup})
