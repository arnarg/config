(import-macros {: wkmap!} :lib.macros)
(import-macros {: nil?} :hibiscus.core)
(import-macros {: map!} :hibiscus.vim)
(local create_augroup vim.api.nvim_create_augroup)
(local create_autocmd vim.api.nvim_create_autocmd)
(local zk (require :zk))
(local zkutil (require :zk.util))

(zk.setup {:picker :telescope})

(wkmap! {:z {:name :Zettelkasten
             :n ["<cmd>ZkNew { title = vim.fn.input(\"Title: \") }<cr>"
                 "New note"]
             :o ["<cmd>ZkNotes { sort = { \"modified\" } }<cr>" "Open note"]
             :t [:<cmd>ZkTags<cr> "Show tags"]
             :f ["<cmd>ZkNotes { sort = { \"modified\" }, match = vim.fn.input(\"Search: \") }<cr>"
                 "Find Notes"]
             :d ["<cmd>ZkNew { dir = \"journal\" }<cr>" "Open daily note"]}}
        {:prefix :<leader>})

(fn on-load []
  (if (not (nil? (zkutil.notebook_root (vim.fn.expand "%:p"))))
      (do
        (map! [n :buffer] :<cr> vim.lsp.buf.definition)
	(map! [n :buffer] :K vim.lsp.buf.hover)
	(map! [n :buffer] :<leader>znt ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>")
	(map! [n :buffer] :<leader>znc ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>")
	(map! [n :buffer] :<leader>zb "<cmd>ZkBacklinks<cr>")
	(map! [n :buffer] :<leader>zl "<cmd>ZkLinks<cr>")
	(map! [n :buffer] :<leader>za vim.lsp.buf.range_code_action)
	nil)))

(local zkgroup (create_augroup :zk {:clear true}))
(create_autocmd [:FileType]
                {:pattern :markdown
                 :callback on-load
		 :group zkgroup})
