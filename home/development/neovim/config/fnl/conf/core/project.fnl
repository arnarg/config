(import-macros {: wkmap!} :lib.macros)

(local project (require :project_nvim))
(local telescope (require :telescope))

(project.setup {:detection_methods [:lsp :pattern]
                :patterns [:.git
                           :Makefile
                           :go.mod
                           :package.json
                           :requirements.txt]})

(telescope.load_extension :projects)

(wkmap! {:s {:name :Switch :p ["<cmd>Telescope projects<cr>" "Switch project"]}}
        {:prefix :<leader>})
