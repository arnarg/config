(import-macros {: wkmap!} :lib.macros)
(local zk (require :zk))

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

;; TODO!
;; vim.api.nvim_create_autocmd('FileType', {
;;   pattern = 'markdown',
;;   callback = function()
;;     if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
;;       local function map(...) vim.api.nvim_buf_set_keymap(0, ...) end
;;       local opts = { noremap=true, silent=false }
;;
;;       -- Open the link under the caret.
;;       map("n", "<cr>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
;;
;;       -- Create a new note in the same directory as the current buffer, using the current selection for title.
;;       map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>", opts)
;;       -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
;;       map("v", "<leader>znc", ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<cr>", opts)
;;
;;       -- Open notes linking to the current buffer.
;;       map("n", "<leader>zb", "<cmd>ZkBacklinks<cr>", opts)
;;       -- Open notes linked by the current buffer.
;;       map("n", "<leader>zl", "<cmd>ZkLinks<cr>", opts)
;;
;;       -- Preview a linked note.
;;       map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
;;       -- Open the code actions for a visual selection.
;;       map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<cr>", opts)
;;     end
;;   end,
;; })
