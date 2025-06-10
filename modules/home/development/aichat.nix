{
  lib,
  pkgs,
  ...
}: let
  gruvbox-theme = pkgs.fetchFromGitHub {
    owner = "subnut";
    repo = "gruvbox-tmTheme";
    rev = "429749e29c84724b72b71a80dfdd67be2e0bc506";
    hash = "sha256-bihd6lgKZygwsgOzp/0/bgt4hWhIrOcBkFhw8giywyk=";
  };

  llm-functions = pkgs.stdenv.mkDerivation {
    name = "llm-functions";

    src = pkgs.fetchFromGitHub {
      owner = "sigoden";
      repo = "llm-functions";
      rev = "afe36700389ddcf9ddc19244bb184df3122b8750";
      hash = "sha256-+w57l6jmJ9F+eJXU3lMJ5BkpL4E5ie3g+KbOYQEF9Ac=";
    };

    nativeBuildInputs = with pkgs; [makeWrapper];

    buildInputs = with pkgs; [
      argc
      jq
    ];

    postPatch = ''
      cat <<EOF > tools.txt
      fs_cat.sh
      fs_ls.sh
      fs_mkdir.sh
      fs_patch.sh
      fs_rm.sh
      fs_write.sh
      fetch_url_via_curl.sh
      get_current_time.sh
      get_current_weather.sh
      EOF

      cat <<EOF > agents.txt
      coder
      EOF
    '';

    buildPhase = ''
      argc build-declarations@tool --names-file tools.txt --declarations-file functions.json
      argc build-declarations@agent --names-file agents.txt

      # Make symlinks in bin
      mkdir bin

      for tool in `cat tools.txt`; do
        tool_name="''${tool%.*}"
        echo "Making symlink for tool $tool_name"

        ln -s "../scripts/run-tool.sh" "bin/$tool_name"
      done

      for agent in `cat agents.txt`; do
        echo "Making symlink for agent $agent"

        ln -s "../scripts/run-agent.sh" "bin/$agent"
      done
    '';

    installPhase = let
      deps = with pkgs; [
        curl
        jq
        argc
        gawk
        git
      ];
    in ''
      mkdir $out
      cp -r {agents,bin,scripts,tools,utils,functions.json,agents.txt,tools.txt} $out/

      for tool in $out/tools/*.sh; do
        wrapProgram $tool \
          --prefix PATH : ${lib.makeBinPath deps}
      done
    '';
  };
in {
  home.packages = with pkgs; [
    aichat
    files-to-prompt
  ];

  # Setup aichat
  xdg.configFile = {
    "aichat/config.yaml" = let
      format = pkgs.formats.yaml {};

      config = {
        model = "mistral:mistral-medium-latest";

        clients = [
          {
            type = "openai-compatible";
            name = "mistral";
            api_base = "https://api.mistral.ai/v1";
          }
          {
            type = "gemini";
            name = "gemini";
            api_base = "https://generativelanguage.googleapis.com/v1beta";
            patch.chat_completions.".*".body.safetySettings = [
              {
                category = "HARM_CATEGORY_HARASSMENT";
                threshold = "BLOCK_NONE";
              }
              {
                category = "HARM_CATEGORY_HATE_SPEECH";
                threshold = "BLOCK_NONE";
              }
              {
                category = "HARM_CATEGORY_SEXUALLY_EXPLICIT";
                threshold = "BLOCK_NONE";
              }
              {
                category = "HARM_CATEGORY_DANGEROUS_CONTENT";
                threshold = "BLOCK_NONE";
              }
            ];
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

    "aichat/functions" = {
      source = llm-functions;
      recursive = false;
    };
  };
}
