(local cmp (require :cmp))
(local lspkind (require :lspkind))

(macro mapping! [func]
  `(fn [fb#]
     (if (cmp.visible)
         (,func {:behavior cmp.SelectBehavior.Insert})
         (fb#))
     nil))

(cmp.setup {:preselect cmp.PreselectMode.None
            :mapping {:<Tab> (mapping! cmp.select_next_item)
                      :<S-Tab> (mapping! cmp.select_prev_item)}
            :sources [{:name :nvim_lsp} {:name :buffer} {:name :path}]
            :formatting {:format (lspkind.cmp_format {:with_text true
                                                      :maxwidth 50})}})
