(import-macros {: setup!} :lib.macros)

(local treesitter (require :nvim-treesitter.configs))
(local treesitterctx (require :treesitter-context))

(setup! treesitter {:ensure_installed [:bash
                                       :c
                                       :cpp
                                       :fennel
                                       :go
                                       :javascript
                                       :json
                                       :markdown
                                       :nix
                                       :org
                                       :python
                                       :todotxt
                                       :typescript
                                       :yaml]
                    :highlight {:enable true}})

(setup! treesitterctx)

