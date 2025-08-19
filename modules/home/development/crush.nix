{pkgs, ...}: let
  extraPackages = with pkgs; [
    # Go
    gopls
    # Python
    (python3.withPackages
      (ps:
        with ps; [
          python-lsp-server
          python-lsp-black
          python-lsp-ruff
        ]))
    ruff
    # Rust
    rust-analyzer
    # YAML
    nodePackages.yaml-language-server
    # Helm
    helm-ls
    # Nix
    nil
    # Markdown
    marksman
  ];
in {
  home.packages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "${lib.getName crush}-wrapped-${lib.getVersion crush}";
      paths = [crush];
      preferLocalBuild = true;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/crush \
          --suffix PATH : ${lib.makeBinPath extraPackages}
      '';
    })
  ];

  xdg.configFile = {
    "crush/crush.json" = let
      config = {
        providers = {
          gemini.api_key = "$(${pkgs.libsecret}/bin/secret-tool lookup llm gemini)";

          mistral = {
            type = "openai";
            base_url = "https://api.mistral.ai/v1";
            api_key = "$(${pkgs.libsecret}/bin/secret-tool lookup llm mistral)";
            models = [
              {
                id = "mistral-large-latest";
                name = "Mistral Large";
                cost_per_1m_in = 2;
                cost_per_1m_out = 6;
                context_window = 128000;
                default_max_tokens = 48000;
              }
              {
                id = "mistral-medium-latest";
                name = "Mistral Medium";
                cost_per_1m_in = 0.4;
                cost_per_1m_out = 2;
                context_window = 128000;
                default_max_tokens = 48000;
              }
              {
                id = "mistral-small-latest";
                name = "Mistral Small";
                cost_per_1m_in = 0.1;
                cost_per_1m_out = 0.3;
                context_window = 128000;
                default_max_tokens = 48000;
              }
              {
                id = "devstral-medium-2507";
                name = "Devstral Medium";
                cost_per_1m_in = 0.4;
                cost_per_1m_out = 2;
                context_window = 128000;
                default_max_tokens = 48000;
              }
            ];
          };

          hyperbolic = {
            type = "openai";
            base_url = "https://api.hyperbolic.xyz/v1";
            api_key = "$(${pkgs.libsecret}/bin/secret-tool lookup llm hyperbolic)";
            models = [
              {
                id = "deepseek-ai/DeepSeek-R1-0528";
                name = "Deepseek R1";
                cost_per_1m_out = 3;
                context_window = 163795;
                default_max_tokens = 50000;
                can_reason = true;
              }
              {
                id = "deepseek-ai/DeepSeek-V3-0324";
                name = "Deepseek V3";
                cost_per_1m_out = 1.25;
                context_window = 131072;
                default_max_tokens = 50000;
                can_reason = false;
              }
              {
                id = "moonshotai/Kimi-K2-Instruct";
                name = "Kimi K2";
                cost_per_1m_out = 2;
                context_window = 131072;
                default_max_tokens = 50000;
                can_reason = false;
              }
            ];
          };
        };
      };
    in {
      text = builtins.toJSON config;
    };
  };
}
