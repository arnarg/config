(local {: postfix} (require :luasnip.extras.postfix))

[(postfix :.setup [(l (.. "(setup! " l.POSTFIX_MATCH " {})"))])
 ;; expand to import-macros
 (s :imacro [(t "(import-macros {: ")
             (i 1 :macro!)
             (t "} :")
             (i 2 :module)
             (t ")")])]

