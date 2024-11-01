# After finishing the configuration wizard change the atload'' ice to:
# -> atload'source ~/.p10k.zsh; _p9k_precmd'
zinit ice lucid atload'source ${ZDOTDIR}/.p10k.zsh; _p9k_precmd' nocd
zinit light romkatv/powerlevel10k

# Zephyr
plugins=(color completion compstyle directory history)

for plugin in "${plugins[@]}"; do
    zinit ice wait lucid multisrc"plugins/$plugin/*.plugin.zsh" pick"/dev/null"
    zinit light mattmc3/zephyr
done

zstyle ':zephyr:plugin:directory:alias' 'skip' 'yes'

# Zsh completions
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit ice lucid nocompile wait'0e' nocompletions
zinit load MenkeTechnologies/zsh-more-completions

# Load completions

autoload -Uz compinit
compinit
zinit cdreplay -q

# Programs

# junegunn/fzf-bin
zinit ice wait lucid from"gh-r" as"program"
zinit light junegunn/fzf-bin

# sharkdp/bat
# zinit ice wait lucid from"gh-r" as"program" mv"bat* -> bat" atload"export BAT_THEME='Nord'"
# zinit light sharkdp/bat

# eza-community/eza, replacement for ls
zinit ice wait"2" lucid from"gh-r" as"program"
zinit light eza-community/eza

zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# Zoxide
# zinit ice from"gh-r" as"command"
# zinit light ajeetdsouza/zoxide

# zsh-autopair
zinit ice wait lucid
zinit load hlissner/zsh-autopair

zinit ice wait"1" lucid
zinit load psprint/zsh-navigation-tools

# fast-syntax-highlighting
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light MichaelAquilina/zsh-you-should-use

# zinit ice wait lucid
# zinit light Aloxaf/fzf-tab

# # preview directory's content with eza when completing cd
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# #
# # switch group using `,` and `.`
# zstyle ':fzf-tab:*' switch-group ',' '.'

zinit ice lucid nocompile
zinit load MenkeTechnologies/zsh-very-colorful-manuals

zinit ice wait'3' lucid
zinit light zsh-users/zsh-history-substring-search

# zdharma-continuum/history-search-multi-word
zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit load zdharma-continuum/history-search-multi-word
