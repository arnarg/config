(local treesitter (require :nvim-treesitter))
(local treesitterctx (require :treesitter-context))

(treesitter.setup {:ensure_installed [:bash
                                      :c
                                      :cpp
                                      :fennel
                                      :go
                                      :javascript
                                      :json
                                      :markdown
                                      :nix
                                      :python
                                      :todotxt
                                      :yaml]
                   :highlight {:enable true}})

(treesitterctx.setup)
