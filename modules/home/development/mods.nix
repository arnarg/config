{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
      openrouter = {
        base-url = "https://openrouter.ai/api/v1";
        api-key-cmd = "${pkgs.libsecret}/bin/secret-tool lookup llm openrouter";
        models = {
          "google/gemini-2.5-flash" = {
            aliases = [
              "gemini-flash"
              "flash"
            ];
            max-input-chars = 1048576;
          };
          "google/gemini-2.5-flash-lite" = {
            aliases = [
              "gemini-flash-lite"
              "flash-lite"
            ];
            max-input-chars = 1048576;
          };
          "google/gemini-2.5-pro" = {
            aliases = [ "gemini-pro" ];
            max-input-chars = 1048576;
          };
          "mistralai/mistral-small-3.2-24b-instruct" = {
            aliases = [ "mistral-small" ];
            max-input-chars = 131072;
          };
          "mistralai/mistral-medium-3.1" = {
            aliases = [ "mistral-medium" ];
            max-input-chars = 131072;
          };
          "mistralai/codestral-2508" = {
            aliases = [ "codestral" ];
            max-input-chars = 256000;
          };
          "qwen/qwen3-235b-a22b-thinking-2507" = {
            aliases = [ "qwen3" ];
            max-input-chars = 262144;
          };
        };
      };

      hyperbolic = {
        base-url = "https://api.hyperbolic.xyz/v1";
        api-key-cmd = "${pkgs.libsecret}/bin/secret-tool lookup llm hyperbolic";
        models = {
          "deepseek-ai/DeepSeek-R1-0528" = {
            aliases = [
              "deepseek-r1"
              "dsr1"
            ];
            max-input-chars = 131072;
          };
          "deepseek-ai/DeepSeek-V3-0324" = {
            aliases = [
              "deepseek-v3"
              "dsv3"
            ];
            max-input-chars = 131072;
          };
          "meta-llama/Llama-3.3-70B-Instruct" = {
            aliases = [
              "llama3"
              "llama"
            ];
            max-input-chars = 131072;
          };
          "moonshotai/Kimi-K2-Instruct" = {
            aliases = [ "kimi-k2" ];
            max-input-chars = 131072;
          };
        };
      };
    };
  };
}
