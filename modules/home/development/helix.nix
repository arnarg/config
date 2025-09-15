{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.development;
in
{
  options.profiles.development.helix = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable helix setup.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.helix.enable) {
    programs.helix.enable = true;
    programs.helix.extraPackages = with pkgs; [
      # General
      harper

      # Go
      gopls
      gotools
      delve
      # Python
      (python3.withPackages (
        ps: with ps; [
          python-lsp-server
          python-lsp-black
          python-lsp-ruff
        ]
      ))
      # Rust
      rust-analyzer
      rustup
      rustfmt
      # YAML
      nodePackages.yaml-language-server
      # Helm
      helm-ls
      # Terraform
      terraform-ls
      # HCL
      hclfmt
      # Nix
      nil
      nixfmt-rfc-style
      # TOML
      taplo
      # Gleam
      gleam
      # d2
      d2
      # python
      ruff
      # Markdown
      marksman

      # For accessing system clipboard
      wl-clipboard
    ];

    programs.helix.settings = {
      theme = "gruvbox";

      editor = {
        # Disable mouse mode
        mouse = false;
        # Enable cursorline
        cursorline = true;
        # Set relative line numbers
        line-number = "relative";
        # Change bg color of current mode in statusline
        color-modes = true;
        # Render indent guides
        indent-guides.render = true;
        # Enable soft-wrap
        soft-wrap.enable = true;
        # By default show no inlay LSP hints
        lsp.display-inlay-hints = false;

        file-picker = {
          # Display hidden files in file picker
          hidden = false;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-type"
            "file-encoding"
          ];
        };
      };

      # Key remapping
      keys = {
        normal = {
          C-r = ":reload";
          C-h = ":toggle-option lsp.display-inlay-hints";
        };
      };
    };

    programs.helix.languages = {
      # Update language server settings
      language-server = {
        yaml-language-server.config = {
          yaml.keyOrdering = false;
        };
        pylsp.config = {
          pylsp.plugins = {
            black.enabled = true;
            ruff.enabled = true;
          };
        };
        harper-ls = {
          command = "harper-ls";
          args = [ "--stdio" ];
          config.harper-ls.linters = {
            SpellCheck = false;
            SentenceCapitalization = false;
          };
        };
      };

      # Update language settings
      language = [
        # Go
        {
          name = "go";
          formatter.command = "goimports";
          language-servers = [
            "gopls"
            "harper-ls"
          ];
        }
        # Nix
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
          language-servers = [
            "nil"
            "harper-ls"
          ];
        }
        # Rust
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "harper-ls"
          ];
        }
        # HCL
        {
          name = "hcl";
          formatter = {
            command = "hclfmt";
          };
        }
        # TOML
        {
          name = "toml";
          file-types = [
            # editorconfig doesn't have .toml extension but is toml
            ".editorconfig"
            "toml"
          ];
        }
        # Gleam
        {
          name = "gleam";
          auto-format = true;
          formatter = {
            command = "gleam";
            args = [
              "format"
              "--stdin"
            ];
          };
        }
        # d2
        {
          name = "d2";
          scope = "text.d2";
          roots = [ ];
          auto-format = true;
          file-types = [ "d2" ];
          formatter = {
            command = "d2";
            args = [
              "fmt"
              "-"
            ];
          };
        }
        # python
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "ruff"
            "harper-ls"
          ];
        }
        # git-commit
        {
          name = "git-commit";
          language-servers = [ "harper-ls" ];
        }
      ];
    };
  };
}
