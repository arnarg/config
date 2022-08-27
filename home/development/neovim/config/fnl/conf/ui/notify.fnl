(import-macros {: setup!} :lib.macros)

(local notify (require :notify))
(local telescope (require :telescope))

(setup! notify {:stages :static})
(telescope.load_extension :notify)
(tset vim :notify notify)

