# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set directory for zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME}/.local/share/zinit/zinit.git"

# Install zinit if its not
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Sources
for file in \
    "${ZINIT_HOME}/zinit.zsh" \
    "$ZDOTDIR/plugins.zsh" \
    "$ZDOTDIR/aliases.zsh"
do 
    source "$file"
done

# prompt init
autoload -Uz promptinit
promptinit; prompt gentoo

# Bindkeys
bindkey -v
bindkey "^E" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

# Shell integration
eval "$(zoxide init --cmd cd zsh)"

# At shell start command
fastfetch -l $(find "$HOME/.config/fastfetch/ascii/" -name "*.txt" | sort -R | head -1)

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
(( ! ${+functions[p10k]} )) || p10k finalize
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

