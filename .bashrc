## ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Customize default shell behaviour
shopt -s autocd ## To do 'cd directory' without typing 'cd directory' and only typing 'directory'
shopt -s cdspell ## To atomatically correct directory path if minor error exists
shopt -s no_empty_cmd_completion ## To not search completion in $PATH when attempted with empty line
shopt -s histappend ## To append history to 'HISTFILE' rather than overwriting it
shopt -s checkwinsize
bind 'set completion-ignore-case on' ## ignore case for completion

HISTCONTROL=ignoreboth ## don't put duplicate lines or lines starting with space in the history
HISTSIZE=-1 ## unlimited history
HISTFILESIZE=-1 ## unlimited history
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/shell/history"

# immideately write history
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# My prompt customization
PS1='\[\033[01;36m\]\u\[\033[01;37m\]@\[\033[01;32m\]\h:\[\033[01;34m\]\w\[\033[00m\]\$ '

if (env | grep -Fq 'DISTROBOX'); then
	PS1="(distrobox) $PROMPT"
fi

# Print exit code on error
EC() {
	echo -e '\e[1;33m'exit code: $?'\e[m'
}
trap EC ERR

if [ -f /usr/share/doc/pkgfile/command-not-found.bash ]; then
	# command not found provided by pkgfile package
	source /usr/share/doc/pkgfile/command-not-found.bash
fi

if [ -f /etc/profile.d/grc.sh ]; then
	# grc colorize (if bash is login shell then sourceing this here is not required)
	export GRC_ALIASES=true
	source /etc/profile.d/grc.sh
fi

# source aliasrc for aliases
#source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
source "$HOME/.config/shell/aliasrc"

# source funtionrc for functions
#source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc"
source "$HOME/.config/shell/functionrc"
