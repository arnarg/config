(import-macros {: map!} :hibiscus.vim)

(require :icon-picker)

(map! [i] :<M-i> :<cmd>PickIconsInsert<cr> "Insert emoji")
(map! [n] :<M-i> :<cmd>PickIcons<cr> "Insert emoji")

