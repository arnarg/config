(import-macros {: setup!} :lib.macros)

(local dressing (require :dressing))

(setup! dressing {:input {:insert_only false
                          :relative :editor
                          :min_width [40 0.5]}})

