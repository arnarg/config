(import-macros {: wkmap! : setup!} :lib.macros)
(import-macros {: nil?} :hibiscus.core)
(import-macros {: map! : exec} :hibiscus.vim)

(local create_augroup vim.api.nvim_create_augroup)
(local create_autocmd vim.api.nvim_create_autocmd)

(local zk (require :zk))
(local zkutil (require :zk.util))

(setup! zk {:picker :telescope})

(wkmap! {:z {:name :Zettelkasten
             :n ["<cmd>ZkNew { title = vim.fn.input(\"Title: \") }<cr>"
                 "New note"]
             :o ["<cmd>ZkNotes { sort = { \"modified\" } }<cr>" "Open note"]
             :t [:<cmd>ZkTags<cr> "Show tags"]
             :f ["<cmd>ZkNotes { sort = { \"modified\" }, match = vim.fn.input(\"Search: \") }<cr>"
                 "Find Notes"]
             :d ["<cmd>ZkNew { dir = \"journal\" }<cr>" "Open daily note"]}}
        {:prefix :<leader>})

;; Runs in every markdown file
(fn on-load []
  ;; Checks if file is in a zk notebook
  (if (not (nil? (zkutil.notebook_root (vim.fn.expand "%:p"))))
      (do
        ;; I don't want zk buffers to hand around as I might
        ;; potentially open them in many vim intances and don't
        ;; want to deal with swap files and such.
        (exec [[:setlocal :bufhidden=delete]])
        (map! [n :buffer] :<cr> vim.lsp.buf.definition)
        (map! [n :buffer] :K vim.lsp.buf.hover)
        (map! [n :buffer] :<leader>znt
              ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>")
        (map! [n :buffer] :<leader>znc
              ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>")
        (map! [n :buffer] :<leader>zb :<cmd>ZkBacklinks<cr>)
        (map! [n :buffer] :<leader>zl :<cmd>ZkLinks<cr>)
        (map! [n :buffer] :<leader>za vim.lsp.buf.range_code_action
              "Code action")
        nil)))

(local zkgroup (create_augroup :zk {:clear true}))
(create_autocmd [:FileType] {:pattern :markdown
                             :callback on-load
                             :group zkgroup})

