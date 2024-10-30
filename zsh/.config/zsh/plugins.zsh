# Zephyr for base conf

plugins=(color completion directory history editor)

for plugin in "${plugins[@]}"; do
    zinit ice wait lucid multisrc"plugins/$plugin/*.plugin.zsh" pick"/dev/null"
    zinit light mattmc3/zephyr
done

# History
HISTFILE="$HOME/.cache/zsh/zhistory"
HISTSIZE=10000
SAVEHIST=HISTSIZE

# Programs

# junegunn/fzf-bin
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf-bin

# sharkdp/bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# eza-community/eza, replacement for ls
zinit ice wait"2" lucid from"gh-r" as"program"
zinit light eza-community/eza

# Plugins

# zsh-autopair
zinit ice wait lucid
zinit load hlissner/zsh-autopair

zinit ice wait"1" lucid
zinit load psprint/zsh-navigation-tools

# fast-syntax-highlighting
zinit ice wait lucid atinit'ZPLGM["COMPINIT_OPTS"]="-C"; zpcompinit; zpcdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions
