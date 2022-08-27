(import-macros {: wkmap!} :lib.macros)

(require :icon-picker)

(wkmap! {:<M-i> [:<cmd>PickIconsInsert<cr> "Insert emoji"]} {:mode :i})
(wkmap! {:<M-i> [:<cmd>PickIcons<cr> "Insert emoji"]} {:mode :n})
