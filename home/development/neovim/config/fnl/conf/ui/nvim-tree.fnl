(import-macros {: map!} :hibiscus.vim)

(let [tree (require :nvim-tree)]
  (tree.setup {:update_cwd true
               :respect_buf_cwd true
               :actions {:open_file {:quit_on_open true}}})
  (map! [n] :<C-n> :<cmd>NvimTreeToggle<cr>))
