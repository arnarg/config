(import-macros {: color! : set!} :hibiscus.vim)

(color! :gruvbox)
(set! :termguicolors true)
(set! :background :dark)
(set! :laststatus 3)
(set! :cursorline true)
(set! :mouse nil)
(each [_ opt (ipairs [:nu :rnu])]
  (set! opt true))

(require :conf.ui.devicons)
(require :conf.ui.bufferline)
(require :conf.ui.lualine)
(require :conf.ui.nvim-tree)
(require :conf.ui.dirbuf)
(require :conf.ui.dressing)
(require :conf.ui.icon-picker)
(require :conf.ui.numb)
(require :conf.ui.numbertoggle)
(require :conf.ui.notify)
(require :conf.ui.scrollbar)

