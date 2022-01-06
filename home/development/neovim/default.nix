{ config, lib, pkgs, ... }:
with lib; {
  config = {

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      inconsolata-nerdfont
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = builtins.readFile ./init.vim;

      extraPackages = with pkgs; [
        ripgrep
      ];

      plugins = with pkgs.vimPlugins; [
        deoplete-go
        deoplete-nvim
        editorconfig-vim
        lush-nvim
        onedark-nvim
        gruvbox-nvim
        fzf-vim
        indent-blankline-nvim-lua
        nerdtree
        tmuxline-vim
        vim-airline
        vim-airline-themes
        vim-devicons
        vim-easymotion
        vim-gitgutter
        vim-go
        vim-nix
        vim-smoothie
        vim-terraform
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "bufstop";
          version = "1.6.2";
          src = pkgs.fetchFromGitHub {
            owner = "mihaifm";
            repo = "bufstop";
            rev = version;
            sha256 = "hWzJWMvfnfweRLTsWYZBIbuCm7rMLYIp0kQrN68oX+A=";
          };
        })
        (pkgs.vimUtils.buildVimPlugin {
          pname = "vim-numbertoggle";
          version = "2017-10-26";
          src = pkgs.fetchFromGitHub {
            owner = "jeffkreeftmeijer";
            repo = "vim-numbertoggle";
            rev = "cfaecb9e22b45373bb4940010ce63a89073f6d8b";
            sha256 = "1rrmvv7ali50rpbih1s0fj00a3hjspwinx2y6nhwac7bjsnqqdwi";
          };
        })
        (pkgs.vimUtils.buildVimPlugin {
          pname = "tmux-navigate";
          version = "2020-05-06";
          src = pkgs.fetchFromGitHub {
            owner = "sunaku";
            repo = "tmux-navigate";
            rev = "52da3cdca6e23fda99e05527093d274622b742cd";
            sha256 = "0njnra2a9c51hxghhqlyvdi4b02wgmfd6jcpfhapcvvv599g8sri";
          };
        })
      ];
    };

  };
}
