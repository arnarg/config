{pkgs, ...}: {
  home.packages = with pkgs; [
    aider-chat
  ];

  # Aider config
  home.file = let
    yamlFormat = pkgs.formats.yaml {};
    jsonFormat = pkgs.formats.json {};
  in {
    ".aider.conf.yml".source = yamlFormat.generate "aider-config" {
      # Set OPENAI_API_KEY in ~/.env
      openai-api-base = "https://api.hyperbolic.xyz/v1/";

      alias = [
        "r1:openai/deepseek-ai/DeepSeek-R1-0528"
        "dsv3:openai/deepseek-ai/DeepSeek-V3-0324"
        "llama:openai/meta-llama/Llama-3.2-3B-Instruct"
        "mistral-large:mistral/mistral-large-latest"
        "mistral-medium:mistral/mistral-medium-latest"
        "mistral-small:mistral/mistral-small-latest"
        "devstral:mistral/devstral-small-2505"
      ];
    };
    ".aider.model.metadata.json".source = jsonFormat.generate "aider-model-metadata-file" {
      "openai/deepseek-ai/DeepSeek-R1-0528" = {
        max_tokens = 163795;
        max_input_tokens = 32000;
        max_output_tokens = 163795;
        input_cost_per_token = 0.000003;
        output_cost_per_token = 0.000003;
        litellm_provider = "openai";
        mode = "chat";
      };
      "openai/deepseek-ai/DeepSeek-V3-0324" = {
        max_tokens = 163795;
        max_input_tokens = 32000;
        max_output_tokens = 163795;
        input_cost_per_token = 0.00000125;
        output_cost_per_token = 0.00000125;
        litellm_provider = "openai";
        mode = "chat";
      };
      "openai/meta-llama/Llama-3.2-3B-Instruct" = {
        max_tokens = 131072;
        max_input_tokens = 32000;
        max_output_tokens = 131072;
        input_cost_per_token = 0.0000001;
        output_cost_per_token = 0.0000001;
        litellm_provider = "openai";
        mode = "chat";
      };
    };
    ".aider.model.settings.yml".source = yamlFormat.generate "aider-model-settings-file" [
      {
        name = "openai/deepseek-ai/DeepSeek-V3-0324";
        edit_format = "diff";
        weak_model_name = null;
        use_repo_map = true;
        send_undo_reply = false;
        lazy = false;
        reminder = "sys";
        examples_as_sys_msg = true;
        cache_control = false;
        caches_by_default = true;
        use_system_prompt = true;
        use_temperature = true;
        streaming = true;
        editor_model_name = null;
        editor_edit_format = null;
        extra_params.max_tokens = 65536;
      }
      {
        name = "openai/deepseek-ai/DeepSeek-R1-0528";
        edit_format = "diff";
        weak_model_name = "openai/meta-llama/Llama-3.2-3B-Instruct";
        use_repo_map = true;
        send_undo_reply = false;
        lazy = false;
        reminder = "sys";
        examples_as_sys_msg = true;
        cache_control = false;
        caches_by_default = true;
        use_system_prompt = true;
        use_temperature = true;
        streaming = true;
        editor_model_name = "openai/deepseek-ai/DeepSeek-V3-0324";
        editor_edit_format = "editor-diff";
        extra_params.max_tokens = 65536;
      }
    ];
  };
}
