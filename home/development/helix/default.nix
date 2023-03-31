{
  lib,
  pkgs,
  ...
}: let
  # Extra packages that should be added to PATH in helix
  extraPaths = with pkgs; [
    # Go
    gopls
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
      mouse = false;
      cursorline = true;
      line-number = "relative";
      indent-guides.render = true;
    };
  };

  programs.helix.languages = [
    {
      name = "nix";
      formatter = {
        command = "alejandra";
        args = ["-"];
      };
    }
    {
      name = "hcl";
      formatter = {
        command = "hclfmt";
      };
    }
  ];
}
