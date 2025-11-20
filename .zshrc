## ~/.zshrc

# History
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/shell/history"
HISTSIZE=1000000
SAVEHIST="$HISTSIZE"

# Shell options
setopt autocd ## auto cd into dir without 'cd'
setopt append_history ## append history to histfile
setopt histignorespace ## ignore spaced histroy
setopt completeinword
setopt interactivecomments ## treat # as comment on interactive shell
setopt histignorealldups
unsetopt beep ## don't beep

## editing mode e=emacs v=vim
bindkey -v

## more keys for easier editing
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^f" history-incremental-search-forward
bindkey "^g" send-break
bindkey "^h" backward-delete-char
bindkey "^n" down-history
bindkey "^p" up-history
bindkey "^r" history-incremental-search-backward
bindkey "^u" redo
bindkey "^w" backward-kill-word
bindkey "^?" backward-delete-char
bindkey "\e[1;5D" backward-word ## ^<- one word back
bindkey "\e[1;5C" forward-word ## $-> one word forward
bindkey "^[[3~" delete-char ## delete key

# #bindkey -e ## emacs style keybindings
# bindkey '^[OH' beginning-of-line ## ^A beginning of line
# bindkey '^[OF' end-of-line ## ^E end of line
# bindkey "\e[1;5D" backward-word ## ^<- one word back
# bindkey "\e[1;5C" forward-word ## $-> one word forward
# bindkey "^r" history-incremental-search-backward ## ^r histroy search
# bindkey "^?" backward-delete-char ## ^? delete character backwords
# bindkey "\e[3~" delete-char ## del delete character

# Completion
zstyle :compinstall filename '/home/asim/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' ## match case insensitively
zstyle ':completion:*' verbose true
zstyle ':completion:*' menu select ## menu selection based completion
#zstyle ':completion:*' list-colors '' ## completion color
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" ## completion color same as ls

autoload -U colors && colors
autoload -Uz compinit
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump" ## move .zcompdump
_comp_options+=(globdots) ## include dot files in completion

# Prompt Customization
#PROMPT='%F{cyan}%n%f@%F{green}%m%f %F{blue}%B%~%b%f  %# '
NEWLINE=$'\n'
PROMPT="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}%b${NEWLINE}$ "
RPROMPT='[%F{yellow}%?%f]'

if (env | grep -Fq 'DISTROBOX'); then
	PROMPT="(distrobox) $PROMPT"
fi

# Plugins sourced

if [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
	# extra/pkgfile
	source /usr/share/doc/pkgfile/command-not-found.zsh
else if [[ -f /etc/zsh_command_not_found ]]; then
	# command-not-found
	source /etc/zsh_command_not_found
fi; fi

if [[ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
	# aur/zsh-fast-syntax-highlighting
	source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
else if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi; fi

if [[ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.zsh ]]; then
	source /usr/share/zsh/plugins/fzf-tab/fzf-tab.zsh
fi

if [[ -f /etc/grc.zsh ]]; then
	# community/grc
	source /etc/grc.zsh
fi

function set_rprompt() {
  if [[ $? -eq 0 ]]; then
    RPROMPT="%F{green}:)%f"
  else
    RPROMPT="%F{red}:(%f"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set_rprompt
# tldr
#eval $(tldr --print-completion zsh)

# case $TERM in
#   xterm*)
#     precmd () {print -Pn "\e]0;%~\a"}
#     ;;
# esac
precmd () { rehash }

# source aliasrc for aliases
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# source funtionrc for functions
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc"
export ROCM_PATH=/opt/rocm
export HSA_OVERRIDE_GFX_VERSION=10.3.0
