HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

setopt extendedglob
setopt globdots
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt inc_append_history
setopt prompt_sp
setopt rm_star_silent
setopt share_history
bindkey -v

autoload -Uz compinit
compinit
autoload -Uz promptinit
promptinit
autoload -Uz colors
colors
autoload -U add-zsh-hook

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'

# === environment check
_has() {
	type $1 &>/dev/null
}

_has_xclip=$(xhost &>/dev/null && _has xclip)
_has_fd=$(_has fd)
_has_fzf=$(_has fzf)
_has_recdirs=$(_has recdirs)
_has_x_session=0
if [[ $(echo $DISPLAY) ]]
then
    _has_x_session=1
fi

# track recent directories
_recdirs_chpwd() {
	~/.bin/recdirs add
}

# alt-a - cd into the recent directory
# adapted from fzf-cd-widget
fzf-cdr-widget() {
  local cmd="recdirs get"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  cd "$dir"
  unset dir # ensure this doesn't end up appearing in prompt expansion
  local ret=$?
  zle reset-prompt
  return $ret
}

if [[ _has_recdirs ]]
then
	add-zsh-hook chpwd _recdirs_chpwd
	zle     -N    fzf-cdr-widget
	bindkey '\eo' fzf-cdr-widget
fi

# === better vi mode ===
# support for more text objects when in vi mode
# clipboard support, if running in xorg

# edit the current command with $EDITOR ctrl+e
autoload -Uz edit-command-line
zle -N edit-command-line
export KEYTIMEOUT=1
bindkey "^e" edit-command-line
bindkey -M vicmd "^e" edit-command-line

# support for quotes and brackets text objects
autoload -U select-quoted
autoload -U select-bracketed
zle -N select-quoted
zle -N select-bracketed
for m in visual viopp; do
	for c in {a,i}{\',\",\`,\/}; do
		bindkey -M $m $c select-quoted
	done
	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
		bindkey -M $m $c select-bracketed
	done
done

# use system clipboard for yank/paste in vi mode
# from https://unix.stackexchange.com/a/390523
function x11-clip-wrap-widgets() {
    local copy_or_paste=$1
    shift
    for widget in $@; do
        if [[ $copy_or_paste == "copy" ]]; then
            eval "function _x11-clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
            "
        else
            eval "function _x11-clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
        fi
        zle -N $widget _x11-clip-wrapped-$widget
    done
}

local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)

local paste_widgets=(
    vi-put-{before,after}
)

# only activate clipboard if we have xclip and an x session
if [[ $_has_xclip && $_has_x_session ]]
then
	x11-clip-wrap-widgets copy $copy_widgets
	x11-clip-wrap-widgets paste $paste_widgets
fi



# === fd options and search history with fzf
if $_has_fd
then
	# load fzf for history search
	FD_EXCLUDES='--exclude .git'
	export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow ${FD_EXCLUDES}"
	export FZF_DEFAULT_OPTS="--reverse"
	export FZF_ALT_C_COMMAND="fd --type d --hidden --follow ${FD_EXCLUDES}"
	export FZF_CTRL_T_COMMAND="fd --type f --type d --hidden --follow ${FD_EXCLUDES}"

	# copy to clipboard with ctrl-y if we have xclip
	if $_has_xclip
	then
		export FZF_CTRL_R_OPTS="--bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -i -sel p -f | xclip -i -sel c)+abort'"
	fi
fi

if $_has_fzf
	then
	# fzf history search and completion of files/directories
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh
	# override completion with ** to use fd instead of find
	# from https://github.com/junegunn/fzf#settings
	_fzf_compgen_path() {
	fd --hidden --follow ${=FD_EXCLUDES} . "$1"
	}

	_fzf_compgen_dir() {
	fd --type d --hidden --follow ${=FD_EXCLUDES} . "$1"
	}
fi

# prompt
precmd() {
	local last_exit_code=$?

	PROMPT="%{$fg[cyan]%}[%~%{$reset_color%}"
	if [[ -v SSH_CLIENT ]]; then
		PROMPT+=" %{$fg[blue]%}@`hostnamectl hostname | head -c 2`%{$reset_color%}"
		print -Pn "\e]0;%~ @`hostnamectl hostname | head -c 2`\a"
	else
		print -Pn "\e]0;%~\a"
	fi
	PROMPT+="%{$fg[cyan]%}]%{$reset_color%}"

	if [[ $last_exit_code -ne 0 ]]
	then
		PROMPT+="%{$fg_bold[red]%}$%{$reset_color%} "
	else
		PROMPT+="%{$fg_bold[cyan]%}$%{$reset_color%} "
	fi
}

tmp() {
	if [ -z "$1" ]
	then
		cd $(mktemp -d)
	else
		mkdir -p /tmp/$1 && cd /tmp/$1
	fi
}

read_stdin_or_clip() {
	python -c 'import sys;import subprocess;print(subprocess.check_output("xclip -selection clipboard -o", shell=True).decode() if sys.stdin.isatty() else sys.stdin.read(), end="")'
}

export EDITOR=nvim
export MANPAGER='nvim +Man!'
export GOPATH=$HOME/.go
export DOTNETPATH=$HOME/.dotnet
export PATH=$HOME/.bin:$HOME/.local/bin:$GOPATH/bin:$DOTNETPATH/tools:$HOME/.cargo/bin:$PATH

# nice colors for jq
export JQ_COLORS="1;31:1;31:1;31:1;31:1;32:1;37:1;37"

alias vim=nvim
alias e='exit'
alias z='zathura'
alias ls='ls --color'
alias l='ls'
alias la='ls -la'
alias c='clear'
alias n='vim "+normal oinbox" "+normal Otags:" "+normal kO" -c "startinsert" ~/.org/data/$(date +%Y.%m.%d.%H.%M.%S).txt; e'
alias gr='go run .'
alias gt='go test .'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git status'
alias gco='git checkout'
alias gc='git commit -v'
alias gca='git commit -a -v'
alias gps='git push'
alias gpl='git pull'
alias wip='git commit -a -m "wip"'
alias yd='yadm diff'
alias yds='yadm diff --staged'
alias yst='yadm status'
alias yc='yadm commit -v'
alias yca='yadm commit -a -v'
alias yps='yadm push'
alias ypl='yadm pull'
alias gtmp='tmp && dir=$(xclip -o -selection clipboard) && git clone "$dir" && cd $(basename "$dir")'
alias disablescreensaver='xset s off && xset -dpms'
alias vj='read_stdin_or_clip | jq 2>&1 | vim -c "set syntax=json" "+normal L" -'

# templates
gotmp() {
	project_name=${1:-tmp}
	tmp
	go mod init "$project_name"
	cat << EOF > main.go
package main

import (
	"fmt"
	"os"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
	}
}

func run() error {
	return nil
}
EOF
	vim main.go
}

# direnv hook
eval "$(direnv hook zsh)"

# local scripts
for file in ~/.zsh_local/*(N)
do
	source "$file"
done
