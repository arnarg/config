{ config, lib, pkgs, ... }:
let
  userName = config.local.home.userName;
in {
  home-manager.users.${userName} = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = ''
        " lets not use arrow keys
        noremap <Up> <NOP>
        noremap <Down> <NOP>
        noremap <Left> <NOP>
        noremap <Right> <NOP>
        inoremap <Up>    <NOP>
        inoremap <Down>  <NOP>
        inoremap <Left>  <NOP>
        inoremap <Right> <NOP>
        """"""""""
        " VIM-GO "
        """"""""""
        
        let g:go_bin_path = $HOME."/go/bin"
        """"""""""""
        " NERDTREE "
        """"""""""""
        " NERDTree on ctrl+n
        let NERDTreeShowHidden=1
        map <silent> <C-n> :NERDTreeToggle<CR>
        " close NERDTree after a file is opened
        let g:NERDTreeQuitOnOpen=1
        """""""
        " FZF "
        """""""
        " make FZF respect gitignore if `ag` is installed
        if (executable('ag'))
            let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
        endif
        nnoremap <C-P> :Files<CR>
        nnoremap <leader>f :Ag<CR>
        """""""""""
        " AIRLINE "
        """""""""""
        let g:airline_powerline_fonts = 1
        let g:airline_theme='wombat'
        """"""""""""
        " DEOPLETE "
        """"""""""""
        let g:deoplete#enable_at_startup = 1
        inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        """"""""""""""""
        " NUMBERTOGGLE "
        """"""""""""""""
        set nu rnu
        """""""""""
        " BUFSTOP "
        """""""""""
        nnoremap <leader>b :BufstopFast<CR>
        nnoremap <leader>, :BufstopBack<CR>
        nnoremap <leader>. :BufstopForward<CR>
        """"""""
        " GOYO "
        """"""""
        nnoremap <leader>g :Goyo<CR>
      '';

      plugins = with pkgs.vimPlugins; [
        nerdtree
        fzf-vim
        vim-go
        vim-terraform
        vim-nix
        vim-airline
        vim-airline-themes
        vim-gitgutter
        deoplete-nvim
        deoplete-go
        goyo-vim
        editorconfig-vim
        (pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "bufstop";
          version = "2017-06-13";
          src = pkgs.fetchFromGitHub {
            owner = "mihaifm";
            repo = "bufstop";
            rev = "edf8567b518dfcfdff3d3b9d9d03ad0847cb079a";
            sha256 = "1dpmkxq3qc7aw456i68303zq2zq8m28l3sv1y8s5rw8dwbcrfcyx";
          };
        })
        (pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "vim-numbertoggle";
          version = "2017-10-26";
          src = pkgs.fetchFromGitHub {
            owner = "jeffkreeftmeijer";
            repo = "vim-numbertoggle";
            rev = "cfaecb9e22b45373bb4940010ce63a89073f6d8b";
            sha256 = "1rrmvv7ali50rpbih1s0fj00a3hjspwinx2y6nhwac7bjsnqqdwi";
          };
        })
      ];
    };
  };
}
