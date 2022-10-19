(import-macros {: wkmap! : setup!} :lib.macros)

(local bufferline (require :bufferline))
(local bl_groups (require :bufferline.groups))
(setup! bufferline
        {:options {:show_buffer_close_icons false
                   :show_close_icon false
                   :diagnostics :nvim_lsp
                   :diagnostics_indicator (fn [count level dict ctx]
                                            (if (level:match :error)
                                                (.. " " count)
                                                ""))
                   :offsets [{:filetype :NvimTree
                              :text "File Explorer"
                              :highlight :Directory
                              :text_align :left}]
                   :groups {:items [(bl_groups.builtin.pinned:with {:icon ""})]}}})

(wkmap! {:b {:name :Buffer
             :p [:<cmd>BufferLinePick<cr> "Pick buffer"]
             :l [:<cmd>BufferLineTogglePin<cr> "Pin buffer"]
             :q {:name "Close buffer"
                 :p [:<cmd>BufferLinePickClose<cr> "Pick buffer to close"]
                 :l [:<cmd>BufferLineCloseLeft<cr>
                     "Close all buffers to the left"]
                 :r [:<cmd>BufferLineCloseRight<cr>
                     "Close all buffers to the rigth"]}
             :> [:<cmd>BufferLineMoveNext<cr> "Move buffer to the right"]
             :< [:<cmd>BufferLineMovePrev<cr> "Move buffer to the left"]}
         :. [:<cmd>BufferLineCycleNext<cr> "Switch to next buffer"]
         "," [:<cmd>BufferLineCyclePrev<cr> "Switch to previous buffer"]}
        {:prefix :<leader>})

