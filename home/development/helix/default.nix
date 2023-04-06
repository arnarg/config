{
  lib,
  pkgs,
  ...
}: let
  # Extra packages that should be added to PATH in helix
  extraPaths = with pkgs; [
    # Go
    gopls
    gotools
    delve
    # Python
    python311Packages.python-lsp-server
    # Rust
    rust-analyzer
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

    # For accessing system clipboard
    wl-clipboard
  ];

  # Wrap helix to add packages above in PATH
  wrappedHelix = pkgs.symlinkJoin {
    name = "helix-wrapped-${lib.getVersion pkgs.helix}";
    paths = [pkgs.helix];
    preferLocalBuild = true;
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm $out/bin/hx
      makeWrapper "${pkgs.helix}/bin/hx" $out/bin/hx \
        --prefix PATH : ${lib.makeBinPath extraPaths}
    '';
  };
in {
  programs.helix.enable = true;
  programs.helix.package = wrappedHelix;

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

      file-picker = {
        # Display hidden files in file picker
        hidden = false;
        # Display git ignored files in file picker
        git-ignore = false;
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
      };
    };
  };

  programs.helix.languages = [
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
  ];
}
