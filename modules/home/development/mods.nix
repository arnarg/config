{pkgs, ...}: {
  home.packages = with pkgs; [
    libsecret
    files-to-prompt
  ];

  programs.mods.enable = true;
  programs.mods.enableZshIntegration = true;
  programs.mods.settings = {
    status-text = "Generating";
    theme = "charm";

    temp = 1.0;
    topp = 1.0;
    topk = 50;

    default-model = "gemini-flash";
    apis = {
      google = {
        api-key-cmd = "secret-tool lookup llm gemini";
        models = {
          "gemini-2.5-flash" = {
            aliases = ["gemini-flash" "flash"];
            max-input-chars = 1048576;
          };
          "gemini-2.5-flash-lite" = {
            aliases = ["gemini-flash-lite" "flash-lite"];
            max-input-chars = 1048576;
          };
          "gemini-2.5-pro" = {
            aliases = ["gemini-pro"];
            max-input-chars = 1048576;
          };
        };
      };

      mistral = {
        base-url = "https://api.mistral.ai/v1";
        api-key-cmd = "secret-tool lookup llm mistral";
        models = {
          mistral-large-latest = {
            aliases = ["mistral-large"];
            max-input-chars = 384000;
          };
          mistral-medium-latest = {
            aliases = ["mistral-medium"];
            max-input-chars = 384000;
          };
          mistral-small-latest = {
            aliases = ["mistral-small"];
            max-input-chars = 384000;
          };
        };
      };

      hyperbolic = {
        base-url = "https://api.hyperbolic.xyz/v1";
        api-key-cmd = "secret-tool lookup llm hyperbolic";
        models = {
          "deepseek-ai/DeepSeek-R1-0528" = {
            aliases = ["deepseek-r1" "dsr1"];
            max-input-chars = 131072;
          };
          "deepseek-ai/DeepSeek-V3-0324" = {
            aliases = ["deepseek-v3" "dsv3"];
            max-input-chars = 131072;
          };
          "meta-llama/Llama-3.3-70B-Instruct" = {
            aliases = ["llama3" "llama"];
            max-input-chars = 131072;
          };
        };
      };
    };
  };
}
