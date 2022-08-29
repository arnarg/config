(local create_augroup vim.api.nvim_create_augroup)
(local create_autocmd vim.api.nvim_create_autocmd)

(local numbertoggle (create_augroup :numbertoggle {:clear true}))
(create_autocmd [:BufEnter :FocusGained :InsertLeave :WinEnter]
                {:command "if &nu && mode() != \"i\" | set rnu | endif"
                 :pattern ["*"]
                 :group numbertoggle})

(create_autocmd [:BufLeave :FocusLost :InsertEnter :WinLeave]
                {:command "if &nu | set nornu | endif"
                 :pattern ["*"]
                 :group numbertoggle})

