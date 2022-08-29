{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    programs.fzf.enable = true;
    programs.fzf.enableZshIntegration = true;
    # fzf keybinding requires perl
    home.packages = [pkgs.perl];

    programs.zsh = rec {
      enable = true;

      dotDir = ".config/zsh";
      enableCompletion = true;
      enableSyntaxHighlighting = true;

      history = {
        size = mkDefault 50000;
        save = mkDefault 500000;
        path = "$HOME/${dotDir}/history";
        ignoreDups = true;
        share = false;
      };

      sessionVariables = {
        PURE_GIT_PULL = 0;
        PURE_PROMPT_SYMBOL = ">>";
        PURE_PROMPT_VICMD_SYMBOL = "<<";
      };

      shellAliases = {
        ls = "${pkgs.coreutils}/bin/ls --color=auto";
        ll = "${pkgs.coreutils}/bin/ls -l --color=auto";
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
            rev = "v1.20.1";
            sha256 = "iuLi0o++e0PqK81AKWfIbCV0CTIxq2Oki6U2oEYsr68=";
          };
        }
        {
          name = "nix-zsh-completions";
          src = fetchFromGitHub {
            owner = "spwhitt";
            repo = "nix-zsh-completions";
            rev = "0.4.4";
            sha256 = "Djs1oOnzeVAUMrZObNLZ8/5zD7DjW3YK42SWpD2FPNk=";
          };
        }
      ];
    };
  };
}
