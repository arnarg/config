(import-macros {: setup!} :lib.macros)

(local parser_path "~/.local/share/nvim/treesitter")

(local treesitter (require :nvim-treesitter.configs))
(local treesitterctx (require :treesitter-context))

(setup! treesitter {:ensure_installed [:bash
                                       :c
                                       :cpp
                                       :fennel
                                       :go
                                       :hcl
                                       :javascript
                                       :json
                                       :markdown
                                       :nix
                                       :org
                                       :python
                                       :todotxt
                                       :typescript
                                       :yaml]
                    :parser_install_dir parser_path
                    :highlight {:enable true}})

(vim.opt.runtimepath:append (vim.fn.expand parser_path ":p"))

(setup! treesitterctx)

