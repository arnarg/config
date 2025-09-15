{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.development;

  dotDir = ".config/zsh";
in
{
  options.profiles.development.zsh = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zsh setup.";
    };
  };

  config =
    with lib;
    mkIf (cfg.enable && cfg.zsh.enable) {
      programs.fzf.enable = true;
      programs.fzf.enableZshIntegration = true;
      # fzf keybinding requires perl
      home.packages = [ pkgs.perl ];

      programs.zsh = {
        inherit dotDir;

        enable = true;

        enableCompletion = true;
        syntaxHighlighting.enable = true;

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

        plugins = with pkgs; [
          {
            name = "powerlevel10k";
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            src = zsh-powerlevel10k;
          }
          {
            name = "zsh-async";
            file = "async.zsh";
            src = fetchFromGitHub {
              owner = "mafredri";
              repo = "zsh-async";
              rev = "v1.8.6";
              hash = "sha256-Js/9vGGAEqcPmQSsumzLfkfwljaFWHJ9sMWOgWDi0NI=";
            };
          }
          {
            name = "nix-zsh-completions";
            src = fetchFromGitHub {
              owner = "spwhitt";
              repo = "nix-zsh-completions";
              rev = "0.5.1";
              sha256 = "sha256-bgbMc4HqigqgdkvUe/CWbUclwxpl17ESLzCIP8Sz+F8=";
            };
          }
        ];

        initContent = ''
          setopt HIST_IGNORE_SPACE

          source ${./zsh/p10k.zsh}

          # Key bindings
          bindkey -v
          bindkey -a '^[[3~' vi-delete
          bindkey -a 'H' beginning-of-line
          bindkey -a 'F' end-of-line

          # Fix backspace not working after returning from cmd mode
          bindkey '^?' backward-delete-char
          bindkey '^h' backward-delete-char

          ${pkgs.nix-your-shell}/bin/nix-your-shell zsh | source /dev/stdin
        '';
      };
    };
}
