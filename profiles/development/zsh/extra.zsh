setopt HIST_IGNORE_SPACE

# Pure theme settings
zstyle ':prompt:pure:path' color red
zstyle ':prompt:pure:prompt:success' color white

# nix-shell
prompt_nix_shell_setup

# Key bindings
bindkey -v
bindkey -a '^[[3~' vi-delete
bindkey -a 'H' beginning-of-line
bindkey -a 'F' end-of-line

# Fix backspace not working after returning from cmd mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
