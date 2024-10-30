# Set directory for zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME}/.local/share/zinit/zinit.git"

# Install zinit if its not
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Sources
for file in \
    "${ZINIT_HOME}/zinit.zsh" \
    "$ZDOTDIR/aliases.zsh" \
    "$ZDOTDIR/plugins.zsh"
do 
    source "$file"
done

# Zsh completions
# zinit ice blockf atpull'zinit creinstall -q .'
# zinit light zsh-users/zsh-completions
#
# zinit ice depth"1" pick"zephyr.zsh"
# zinit load mattmc3/zephyr

# Zinit snippets
# zinit snippet OMZP::git
# zinit snippet OMZP::dotenv
# zinit snippet OMZP::command-not-found

# Load completions

autoload -Uz promptinit
# compinit
promptinit; prompt gentoo
# zinit cdreplay -q

# Load zsh plugins
# zinit light-mode for \
#   hlissner/zsh-autopair \
#   zdharma-continuum/fast-syntax-highlighting \
#   MichaelAquilina/zsh-you-should-use \
#   zsh-users/zsh-autosuggestions \
#   Aloxaf/fzf-tab

# zinit ice wait'3' lucid
# zinit light zsh-users/zsh-history-substring-search
#
# zinit ice wait'2' lucid
# zinit light zdharma-continuum/history-search-multi-word

# FZF
# zinit ice from"gh-r" as"command"
# zinit light junegunn/fzf-bin

# Zoxide
# zinit ice from"gh-r" as"command"
# zinit light ajeetdsouza/zoxide

# EZA
# zinit ice wait lucid from"gh-r" as"program" mv"eza* -> eza"
# zinit light eza-community/eza

# BAT
# zinit ice wait lucid from"gh-r" as"program" mv"*/bat -> bat" atload"export BAT_THEME='Nord'"
# zinit light sharkdp/bat

# Options

# Bindkeys
bindkey -v
bindkey "^E" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

# preview directory's content with exa when completing cd
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
#
# switch group using `,` and `.`
# zstyle ':fzf-tab:*' switch-group ',' '.'

# Shell integration
# eval "$(zoxide init --cmd cd zsh)"

# TODO: fix termux startup(install display manager) #
# At shell start command
# [ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit;}
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#     exec tmux new-session && exit
# fi
#
fastfetch -l $(find "$HOME/.config/fastfetch/ascii/" -name "*.txt" | sort -R | head -1)
