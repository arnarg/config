{ config, lib, pkgs, ... }:
with lib; {
  config = {

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = builtins.readFile ./init.vim;

      plugins = with pkgs.vimPlugins; [
        deoplete-go
        deoplete-nvim
        editorconfig-vim
        fzf-vim
        goyo-vim
        nerdtree
        vim-airline
        vim-airline-themes
        vim-gitgutter
        vim-go
        vim-nix
        vim-terraform
        vim-easymotion
        vimwiki
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
        (pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "tmux-navigate";
          version = "2020-05-06";
          src = pkgs.fetchFromGitHub {
            owner = "sunaku";
            repo = "tmux-navigate";
            rev = "52da3cdca6e23fda99e05527093d274622b742cd";
            sha256 = "0njnra2a9c51hxghhqlyvdi4b02wgmfd6jcpfhapcvvv599g8sri";
          };
        })
        (pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "tmuxline";
          version = "2019-12-21";
          src = pkgs.fetchFromGitHub {
            owner = "edkolev";
            repo = "tmuxline.vim";
            rev = "7001ab359f2bc699b7000c297a0d9e9a897b70cf";
            sha256 = "13d87zxpdzryal5dkircc0sm88mwwq7f5n4j3jn9f09fmg9siifb";
          };
        })
      ];
    };

  };
}
