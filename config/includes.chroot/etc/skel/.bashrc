# ===================== ElaOS · bash =====================
[ -z "$PS1" ] && return

HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize

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

# --- Prompt Starship ---
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

if [[ $- == *i* ]]; then
    # Asistente de personalización (solo la primera vez)
    if [[ ! -f "$HOME/.config/elaos/term-setup-done" ]] && command -v elaos-term-setup >/dev/null 2>&1; then
        elaos-term-setup || true
    fi
    # Bienvenida con el logo de ElaOS
    command -v fastfetch >/dev/null 2>&1 && fastfetch
fi
