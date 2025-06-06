{pkgs, ...}: let
  gruvbox-theme = pkgs.fetchFromGitHub {
    owner = "subnut";
    repo = "gruvbox-tmTheme";
    rev = "429749e29c84724b72b71a80dfdd67be2e0bc506";
    hash = "sha256-bihd6lgKZygwsgOzp/0/bgt4hWhIrOcBkFhw8giywyk=";
  };
in {
  home.packages = with pkgs; [
    aichat
  ];

  # Setup aichat
  xdg.configFile = {
    "aichat/config.yaml" = let
      format = pkgs.formats.yaml {};

      config = {
        model = "mistral:mistral-large-latest";

        clients = [
          {
            type = "openai-compatible";
            name = "mistral";
            api_base = "https://api.mistral.ai/v1";
          }
          {
            type = "openai-compatible";
            name = "hyperbolic";
            api_base = "https://api.hyperbolic.xyz/v1";
            models = [
              {
                name = "deepseek-ai/DeepSeek-R1-0528";
                max_input_tokens = 131072;
              }
              {
                name = "deepseek-ai/DeepSeek-V3-0324";
                max_input_tokens = 131072;
              }
              {
                name = "meta-llama/Llama-3.3-70B-Instruct";
                max_input_tokens = 131072;
              }
            ];
          }
        ];
      };
    in {
      source = format.generate "aichat-config" config;
    };

    "aichat/dark.tmTheme".source = "${gruvbox-theme}/gruvbox (Dark) (Medium).tmTheme";
    "aichat/light.tmTheme".source = "${gruvbox-theme}/gruvbox (Light) (Medium).tmTheme";
  };
}
