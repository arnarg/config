{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.development;
in {
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
      # Go
      gopls
      gotools
      delve
      # Python
      python311Packages.python-lsp-server
      # Rust
      rust-analyzer
      rustup
      rustfmt
      # YAML
      nodePackages.yaml-language-server
      # Terraform
      terraform-ls
      # HCL
      hclfmt
      # Nix
      nil
      alejandra
      # TOML
      taplo
      # Gleam
      gleam
      # d2
      d2

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
          left = ["mode" "spinner" "file-name"];
          right = ["diagnostics" "selections" "position" "file-type" "file-encoding"];
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
        yaml-language-server.config = {yaml.keyOrdering = false;};
      };

      # Update language settings
      language = [
        # Go
        {
          name = "go";
          formatter = {
            command = "goimports";
          };
        }
        # Nix
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "alejandra";
            args = ["-"];
          };
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
            args = ["format" "--stdin"];
          };
        }
        # d2
        {
          name = "d2";
          scope = "text.d2";
          roots = [];
          auto-format = true;
          file-types = ["d2"];
          formatter = {
            command = "d2";
            args = ["fmt" "-"];
          };
        }
      ];
    };
  };
}
