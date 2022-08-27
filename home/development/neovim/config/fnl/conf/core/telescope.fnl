(import-macros {: wkmap!} :lib.macros)
(import-macros {: map!} :hibiscus.vim)

(wkmap! {:f {:name :Find
             :f ["<cmd>Telescope live_grep<cr>" "Find text"]
             :c ["<cmd>Telescope git_commits<cr>" "Find commits"]}
         :s {:name :Switch
             :t ["<cmd>Telescope filetypes<cr>" "Switch filetype"]}}
        {:prefix :<leader>})

(map! [n] :<C-P> "<cmd>Telescope find_files<cr>" "Find files")
