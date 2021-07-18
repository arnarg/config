{ config, lib, pkgs, ... }:
with lib; {
  config = {

    programs.fzf.enable = true;
    programs.fzf.enableZshIntegration = true;
    # fzf keybinding requires perl
    home.packages = [ pkgs.perl ];


    programs.zsh = rec {
      enable = true;

      dotDir = ".config/zsh";
      # This causes a lot of slowdown on zsh startup
      enableCompletion = false;
      enableAutosuggestions = false;

      history = {
        size = mkDefault 50000;
        save = mkDefault 500000;
        path = "$HOME/${dotDir}/history";
        ignoreDups = true;
        share = false;
      };

      sessionVariables = {
        EDITOR   = "nvim";
        LC_CTYPE = "en_US.UTF-8";
        PURE_GIT_PULL = 0;
        PURE_PROMPT_SYMBOL = ">>";
        PURE_PROMPT_VICMD_SYMBOL = "<<";
      };

      shellAliases = {
        ls  = "${pkgs.coreutils}/bin/ls --color=auto";
        ll  = "${pkgs.coreutils}/bin/ls -l --color=auto";
        cat = "${pkgs.bat}/bin/bat -p";
        ssh = "TERM=xterm-256color ${pkgs.openssh}/bin/ssh";
      };

      initExtra = mkBefore (
        builtins.readFile ./extra.zsh
        + "\n${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
      );

      plugins = with pkgs; [
        {
          name = "pure";
          src = fetchFromGitHub {
            owner = "sindresorhus";
            repo = "pure";
            rev = "v1.11.0";
            sha256 = "0nzvb5iqyn3fv9z5xba850mxphxmnsiq3wxm1rclzffislm8ml1j";
          };
        }
        {
          name = "nix-zsh-completions";
          src = fetchFromGitHub {
            owner = "spwhitt";
            repo = "nix-zsh-completions";
            rev = "0.4.3";
            sha256 = "0fq1zlnsj1bb7byli7mwlz7nm2yszwmyx43ccczcv51mjjfivyp3";
          };
        }
      ];
    };

  };
}
