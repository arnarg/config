(import-macros {: wkmap!} :lib.macros)
(import-macros {: nil?} :hibiscus.core)
(import-macros {: map!} :hibiscus.vim)

(local setbufopt! vim.api.nvim_buf_set_option)
(local cmp-lsp (require :cmp_nvim_lsp))
(local lspconfig (require :lspconfig))
(local {: path} (require :lspconfig.util))
(local capabilities
       (cmp-lsp.default_capabilities (vim.lsp.protocol.make_client_capabilities)))

(fn on-attach [client bufnr]
  (setbufopt! bufnr :omnifunc "v:lua.vim.lsp.omnifunc")
  (map! [n] :<C-k> vim.lsp.buf.signature_help "Signature help")
  (wkmap! {:K [vim.lsp.buf.hover "Show signature"]
           :g {:D [vim.lsp.buf.declaration "Go to declaration"]
               :d [vim.lsp.buf.defintion "Go to definition"]
               :i [vim.lsp.buf.implementation "Go to implementation"]
               :r [vim.lsp.buf.references "Go to references"]}
           :D [vim.lsp.buf.type_definition "Show type definition"]
           :rn [vim.lsp.buf.rename :Rename]
           :ca [vim.lsp.buf.code_action "Code action"]
           :f [vim.lsp.buf.formatting :Formatting]}
          {:noremap true :silent true :buffer bufnr}))

(map! [n] :<space>e vim.diagnostic.open_float)
(map! [n] "[d" vim.diagnostic.goto_prev)
(map! [n] "]d" vim.diagnostic.goto_next)
(map! [n] :<space>q vim.diagnostic.setloclist)

(macro setup-lsp [name conf]
  `((. lspconfig ,name :setup) ,conf))

;; gopls
(setup-lsp :gopls {:on_attach on-attach : capabilities})

;; clojure-lsp
(setup-lsp :clojure_lsp {:on_attach on-attach : capabilities})

;; rust_analyzer
(setup-lsp :rust_analyzer {:on_attach on-attach : capabilities})

;; rnix
(setup-lsp :rnix {:on_attach on-attach : capabilities})

;; yamlls
(setup-lsp :yamlls
           {:on_attach on-attach
            : capabilities
            :settings {:yaml {:schemas {"https://json.schemastore.org/kustomization" :kustomization.yaml}}}})

;; pyright
(fn find-venv [ws]
  (local m (vim.fn.glob (path.join ws :venv)))
  (if m m))

(fn setup-venv [venv]
  (tset vim :env :VIRTUAL_ENV venv)
  (tset vim :env :PATH (path.join venv "/bin:" (. vim :env :PATH)))
  nil)

(fn py-path [ws]
  (let [venv (find-venv ws)]
    (if (not (nil? venv))
        (do
          (setup-venv venv)
          (path.join venv :bin :python))
        (or (exepath :python3) (exepath :python) :python))))

(fn before-init [_ conf]
  (tset conf :settings :python :pythonPath (py-path (. conf :root_dir))))

(setup-lsp :pyright {:on_attach on-attach
                     : capabilities
                     :before_init before-init})

nil

