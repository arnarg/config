(local notify (require :notify))
(local telescope (require :telescope))

(notify.setup {:stages :static})
(telescope.load_extension :notify)
(tset vim :notify notify)
