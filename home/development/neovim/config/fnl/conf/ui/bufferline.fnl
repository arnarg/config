(import-macros {: wkmap! : setup!} :lib.macros)

(local bufferline (require :bufferline))
(setup! bufferline
        {:options {:show_buffer_close_icons false
                   :show_close_icon false
                   :offsets [{:filetype :NvimTree
                              :text "File Explorer"
                              :highlight :Directory
                              :text_align :left}]}})

(wkmap! {:b {:name :Buffer
             :p [:<cmd>BufferLinePick<cr> "Pick buffer"]
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

