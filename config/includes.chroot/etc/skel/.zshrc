# ===================== ElaOS · zsh =====================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE
setopt AUTO_CD CORRECT
autoload -Uz compinit && compinit -u 2>/dev/null

# --- Aliases ElaOS ---
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
else
    alias ll='ls -la'
fi
command -v batcat >/dev/null 2>&1 && alias cat='batcat --style=plain --paging=never'
alias grep='grep --color=auto'
alias modo='sudo elaos-mode'
alias tema='elaos-term-theme'

# --- Prompt Starship (paleta de marca) ---
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# --- Bienvenida con el logo de ElaOS ---
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi
