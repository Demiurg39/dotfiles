# Aliases
alias cl="clear"
alias mkgrub='doas grub-mkconfig -o /boot/grub/grub.cfg'

# Set directory aliases.
# alias -- -='cd -'
alias dirh='dirs -v'
alias ..="cd .."

for _index in {0..9}; do
    alias "$_index"="cd -${_index}" # dirstack aliases (eg: "2"="cd -2")
    alias "..${_index}"="cd ../.."  # backref aliases (eg: "..3"="cd ../../..")
done

alias sudo="doas"
alias ls="eza --color=always --icons=always"
alias cat="bat --color always --plain --paging never"
alias less="bat --color always --paging always"
alias mkdir="mkdir -p"
alias grep="grep --color=auto"
alias mv="mv -v"
alias cp="cp -vr"
alias rm="rm -vr"
alias fm="yazi"
alias uz="unzip"
alias diff="diff --color"
alias stl="steamtinkerlaunch"
alias open='xdg-open'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# Gentoo specific aliasses
alias emin="doas emerge"
alias eminb="doas emerge -G"
alias emrem="doas emerge -C"
alias emsearch="emerge -s"
alias eisync="doas eix-sync"
alias emsync="doas emerge --sync"
alias emup="doas emerge -uN @world"
alias emclean="doas emerge --depclean"
alias distclean="doas eclean --deep distfiles"
alias pkgclean="doas eclean-pkg"

alias newuse="doas euse -E"
alias deluse="doas euse -D"

alias make.conf="doas nvim /etc/portage/make.conf"
alias package.use="doas nvim /etc/portage/package.use"
alias package.accept="doas nvim /etc/portage/package.accept_keywords"
alias package.mask="doas nvim /etc/portage/package.mask"
