{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.development;
in {
  options.profiles.development.zsh = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zsh setup.";
    };
  };

  config = with lib;
    mkIf (cfg.enable && cfg.zsh.enable) {
      programs.fzf.enable = true;
      programs.fzf.enableZshIntegration = true;
      # fzf keybinding requires perl
      home.packages = [pkgs.perl];

      programs.zsh = rec {
        enable = true;

        dotDir = ".config/zsh";
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

        initExtra = mkBefore ''
          setopt HIST_IGNORE_SPACE

          # Pure theme settings
          zstyle ':prompt:pure:path' color '#fb4934'
          zstyle ':prompt:pure:prompt:success' color white

          # nix-shell
          prompt_nix_shell_setup

          # Key bindings
          bindkey -v
          bindkey -a '^[[3~' vi-delete
          bindkey -a 'H' beginning-of-line
          bindkey -a 'F' end-of-line

          # Fix backspace not working after returning from cmd mode
          bindkey '^?' backward-delete-char
          bindkey '^h' backward-delete-char

          ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
        '';

        plugins = with pkgs; [
          {
            name = "pure";
            src = fetchFromGitHub {
              owner = "sindresorhus";
              repo = "pure";
              rev = "v1.22.0";
              sha256 = "sha256-TR4CyBZ+KoZRs9XDmWE5lJuUXXU1J8E2Z63nt+FS+5w=";
            };
          }
          {
            name = "nix-zsh-completions";
            src = fetchFromGitHub {
              owner = "spwhitt";
              repo = "nix-zsh-completions";
              rev = "0.5.0";
              sha256 = "sha256-DKvCpjAeCiUwD5l6PUW7WlEvM0cNZEOk41IiVXoh9D8=";
            };
          }
        ];
      };
    };
}
