{ config, lib, pkgs, ... }:
let
  hibiscus = pkgs.stdenv.mkDerivation rec {
    pname = "hibiscus-nvim";
    version = "v1.2";

    src = pkgs.fetchFromGitHub {
      owner = "udayvir-singh";
      repo = "hibiscus.nvim";
      rev = version;
      sha256 = "BPLu65WD0dfim2kuJkPXsYxbt7Eatn4ej+ktLhUY+hs=";
    };

    phases = "unpackPhase patchPhase installPhase";

    patchPhase = ''
      sed -i"" -e 's|vim\.|_G.vim.|g' fnl/hibiscus/*.fnl
    '';

    installPhase = ''
      mkdir $out
      cp -r fnl $out
    '';
  };

  cfg = pkgs.stdenv.mkDerivation rec {
    name = "neovim-config-fennel";

    src = ./config;

    buildInputs = [ pkgs.fennel ];

    FENNEL_PATH = "${src}/fnl/?.fnl;;";
    FENNEL_MACRO_PATH = "${FENNEL_PATH};${hibiscus}/fnl/?.fnl;;";

    buildPhase = ''
      # Compile rest of the modules
      base_dir="${src}/fnl"
      while read file; do
        echo "compiling $file"
        mkdir -p "lua/$(dirname $file)"
        fennel --compile "''${base_dir}/''${file}" > "lua/''${file%.fnl}.lua"
      done < <(find "$base_dir" -type f -name '*.fnl' ! -name 'macros.fnl' | sed -e "s|$base_dir/||g")
    '';

    installPhase = ''
      mkdir $out
      cp -r * $out
    '';
  };
in with lib; {
  config = {

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      inconsolata-nerdfont
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    # Put my config derivation in ~/.config/nvim
    xdg.configFile.nvim = {
      source = cfg;
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        curl
        gnutar
        ripgrep
        zk

        # For Treesitter
        gcc

        #########
        ## LSP ##
        #########
        gopls
        pyright
        rnix-lsp
        rust-analyzer
        nodePackages.yaml-language-server

        # For rust-analyzer
        cargo
        rustc

        ###############
        ## Languages ##
        ###############
        go

        # Formatters
        stylua # Lua
        fnlfmt # Fennel
        alejandra # Nix
        black # Python
        nodePackages.prettier # Javascript
      ] ++ optionals pkgs.stdenv.isLinux [
        wl-clipboard
      ];

      plugins = with pkgs.vimPlugins; mkBefore [
        ##########
        ## CORE ##
        ##########
        # Which-key
        which-key-nvim

        # LSP
        cmp-nvim-lsp
        lspkind-nvim
        nvim-lspconfig

        # Treesitter
        nvim-treesitter
        nvim-treesitter-context
        nvim-gps

        # Autocomplete
        cmp-buffer
        cmp-path
        nvim-cmp

        # Telescope
        telescope-nvim

        # Formatter
        formatter-nvim

        # Commenting plugin
        comment-nvim

        # Icon picker
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "icon-picker-nvim";
            version = "2022-07-17";
            src = pkgs.fetchFromGitHub {
              owner = "ziontee113";
              repo = "icon-picker.nvim";
              rev = "fddd49e084d67ed9b98e4c56b1a2afe6bf58f236";
              sha256 = "/4OeBu41PRW8hNI/166Y7Qv4OxmolBr/orarfXAw8mA=";
            };
          };
        }

        # ZK
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "zk-nvim";
            version = "2022-07-14";
            src = pkgs.fetchFromGitHub {
              owner = "mickael-menu";
              repo = "zk-nvim";
              rev = "73affbc95fba3655704e4993a8929675bc9942a1";
              sha256 = "BQrF88hVSDc9zjCWcSSCnw1yhCfMu8zsMbilAI0Xh2c=";
            };
          };
        }

        # misc
        numb-nvim
        editorconfig-nvim
        plenary-nvim
        gitsigns-nvim
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "tmux-navigate";
            version = "2020-05-06";
            src = pkgs.fetchFromGitHub {
              owner = "sunaku";
              repo = "tmux-navigate";
              rev = "52da3cdca6e23fda99e05527093d274622b742cd";
              sha256 = "0njnra2a9c51hxghhqlyvdi4b02wgmfd6jcpfhapcvvv599g8sri";
            };
          };
        }
        {
          plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "project-nvim";
            version = "2022-05-29";
            src = pkgs.fetchFromGitHub {
              owner = "ahmedkhalf";
              repo = "project.nvim";
              rev = "541115e762764bc44d7d3bf501b6e367842d3d4f";
              sha256 = "n5rbD0gBDsYSYvrjCDD1pWqS61c9/nRVEcyiVha0S20=";
            };
          };
        }

        ########
        ## UI ##
        ########
        dressing-nvim
        nui-nvim
        lush-nvim
        indent-blankline-nvim-lua
        nvim-web-devicons
        gruvbox-nvim
        lualine-nvim
        vim-numbertoggle
        nvim-tree-lua
        bufferline-nvim
        nvim-notify
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "dirbuf-nvim";
            version = "2022-08-03";
            src = pkgs.fetchFromGitHub {
              owner = "elihunter173";
              repo = "dirbuf.nvim";
              rev = "e0044552dfd865556e2ea5e603e4d56f705c5bba";
              sha256 = "+lEylPTzChCeUkNl+DfUnIEJCR3A5/xqLxJY1sWlzDM=";
            };
          };
        }
        {
          plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "nvim-scrollbar";
            version = "2022-02-26";
            src = pkgs.fetchFromGitHub {
              owner = "petertriho";
              repo = "nvim-scrollbar";
              rev = "b10ece8f991e2c096bc2a6a92da2a635f9298d26";
              sha256 = "0IwTzVgYi2Z7M2+vJuP+lrKVrTOBWdrIi3mtsj0E+wg=";
            };
          };
        }

        ###############
        ## LANGUAGES ##
        ###############
        {
          plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "go-nvim";
            version = "2022-06-03";
            src = pkgs.fetchFromGitHub {
              owner = "ray-x";
              repo = "go.nvim";
              rev = "b22f8c7760727d8acace61711a9f095142e87099";
              sha256 = "iqVG4zrrnoFe0mNbhKTREM3CvjODUsmgrSRyXjingjY=";
            };
          };
        }

        ############
        ## LEGACY ##
        ############
        vim-nix

        # TODO-PROMPT
        # {
        #   plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
        #     pname = "todotxt-nvim";
        #     version = "2022-02-08";
        #     src = pkgs.fetchFromGitHub {
        #       owner = "arnarg";
        #       repo = "todotxt.nvim";
        #       rev = "646198187f5d8bcf28b0cfa66f95d1aef165064a";
        #       sha256 = "5EZ430P3kmXV+xM+G0n0CyV2UtpOa2T3zTheVwTQ8Wo=";
        #     };
        #   };
        #   type = "lua";
        #   config = ''
        #     require('todotxt-nvim').setup({
        #       todo_file = "~/Documents/todo.txt",
        #     })
        #
        #     if wk ~= nil then
        #       wk.register({
        #         t = {
        #           name = 'Tasks',
        #           t = { '<cmd>ToDoTxtTasksToggle<cr>', 'Toggle tasks pane' },
        #           a = { '<cmd>ToDoTxtCapture<cr>', 'Capture task' },
        #         },
        #       }, { prefix = '<leader>' })
        #     end
        #     -- nnoremap <leader>a <cmd>ToDoTxtCapture<cr>
        #     -- nnoremap <leader>l <cmd>ToDoTxtTasksToggle<cr>
        #   '';
        # }
      ];
    };

  };
}
