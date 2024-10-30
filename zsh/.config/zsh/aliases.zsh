# Aliases
alias cl="clear"
alias mkgrub='doas grub-mkconfig -o /boot/grub/grub.cfg'
alias ..="cd .."
alias sudo="doas"
alias ls="eza --color=always"
alias cat="bat --color always --plain"
alias mkdir="mkdir -p"
alias grep='grep --color=auto'
alias mv='mv -v'
alias cp='cp -vr'
alias rm='rm -vr'
alias fm='yazi'
alias uz='unzip'
alias stl="steamtinkerlaunch"
alias open='xdg-open'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# Gentoo specific aliasses
alias emin="doas emerge"
alias eminrb="doas emerge -G"
alias emrem="doas emerge -C"
alias emsearch="emerge -s"
alias eisync="doas eix-sync"
alias emsync="doas emerge --sync"
alias emup="doas emerge -auDN @world"
alias emclean="doas emerge --depclean"
alias distclean="doas eclean --deep distfiles"
alias pkgclean="doas eclean-pkg"

alias newuse="doas euse -E"
alias deluse="doas euse -D"

alias make.conf="doas nvim /etc/portage/make.conf"
alias package.use="doas nvim /etc/portage/package.use"
alias package.accept="doas nvim /etc/portage/package.accept_keywords"
alias package.mask="doas nvim /etc/portage/package.mask"
