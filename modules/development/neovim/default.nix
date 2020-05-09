{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.neovim;
in with lib; {
  options.local.development.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {

    home-manager.users.arnar = {
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
        ];
      };
    };

  };
}
