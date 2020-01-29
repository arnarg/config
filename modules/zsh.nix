{ config, lib, pkgs, ... }:
let
  cfg = config.local.zsh;
  userName = config.local.home.userName;
in with pkgs.stdenv; with lib; {
  options.local.zsh = {
    enableOktaAws = mkOption {
      type = types.bool;
      default = false;
      description = "Wether okta-aws should be enabled";
    };
  };

  config = {
    home-manager.users.${userName} = {
      programs.zsh = rec {
        enable = true;
  
        dotDir = ".config/zsh";
        # This causes a lot of slowdown on zsh startup
        enableCompletion = false;
        enableAutosuggestions = false;
  
        history = {
          size = 50000;
          save = 500000;
          path = "${dotDir}/history";
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
        };
  
        initExtra = mkBefore (''
          setopt HIST_IGNORE_SPACE
  
          # Pure theme settings
          zstyle ':prompt:pure:path' color red
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
        '' + optionalString cfg.enableOktaAws ''
          # Okta
          . ${pkgs.mypkgs.okta-aws}/bash_functions
          okta-plz() {
            PROFILE="''${1:-$AWS_PROFILE}"
            [[ -z "''${PROFILE}" ]] && echo 'AWS_PROFILE unset' && return 1
            okta-aws "''${PROFILE}" sts get-caller-identity
          }
        '');
  
        plugins = with pkgs; [
          {
            name = "pure";
            src = fetchFromGitHub {
              owner = "sindresorhus";
              repo = "pure";
              rev = "v1.11.0";
              sha256 = "0nzvb5iqyn3fv9z5xba850mxphxmnsiq3wxm1rclzffislm8ml1j";
              # Repository includes a symlink async that points to async.zsh
              # This is stripped for some reason so I add it manually
              extraPostFetch = optionalString isDarwin ''
                chmod u+w $out
                ln -s async.zsh $out/async
                chmod u-w $out
              '';
            };
          }
          {
            name = "nix-shell";
            src = fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "b2609ca787803f523a18bb9f53277d0121e30389";
              sha256 = "01w59zzdj12p4ag9yla9ycxx58pg3rah2hnnf3sw4yk95w3hlzi6";
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
  };
}
