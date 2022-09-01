(import-macros {: setup!} :lib.macros)

(local cmp (require :cmp))
(local lspkind (require :lspkind))
(local luasnip (require :luasnip))

(macro mapping! [func]
  `(fn [fb#]
     (if (cmp.visible) (,func {:behavior cmp.SelectBehavior.Insert})
         (luasnip.expand_or_locally_jumpable) (luasnip.expand_or_jump)
         (fb#))
     nil))

(setup! cmp
        {:preselect cmp.PreselectMode.None
         :mapping {:<Tab> (mapping! cmp.select_next_item)
                   :<S-Tab> (mapping! cmp.select_prev_item)
                   :<C-c> (cmp.mapping.abort)
                   :<CR> (cmp.mapping.confirm {:select true})}
         :sources [{:name :nvim_lsp}
                   {:name :buffer}
                   {:name :path}
                   {:name :luasnip}
                   {:name :orgmode}]
         :snippet {:expand (fn [args]
                             (luasnip.lsp_expand args.body))}
         :formatting {:format (lspkind.cmp_format {:with_text true
                                                   :maxwidth 50})}})

