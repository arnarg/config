{ config, lib, pkgs, ... }:
let
  cfg = config.local.development.zsh;
  userName = config.local.userName;
in with pkgs.stdenv; with lib; {
  options.local.development.zsh = {
    enable = mkEnableOption "zsh";
    enableOktaAws = mkEnableOption "okta-aws";
  };

  config = mkIf cfg.enable {

    programs.zsh.enable = true;
    users.users.${userName}.shell = pkgs.zsh;

    home-manager.users.${userName} = {
      
      programs.fzf.enable = true;
      programs.fzf.enableZshIntegration = true;


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
  
        initExtra = mkBefore (builtins.readFile ./extra.zsh);
  
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
