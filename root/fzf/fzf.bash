#!/bin/bash

# Extended-search-mode
# 
# 'wild	exact-match
# or start fzf with -e
# Reference: https://github.com/junegunn/fzf#extended-search-mode

alias fzfcd='cd "$(find * -type d | fzf)"'

# Reference: https://github.com/junegunn/fzf/tree/master/shell
source ~/vimrc/root/fzf/key-bindings.bash
source ~/vimrc/root/fzf/completion.bash

# Reference: https://github.com/lincheney/fzf-tab-completion
source ~/vimrc/root/fzf/fzf-bash-completion.sh
bind -x '"\C-f": fzf_bash_completion'

# Reference: https://github.com/junegunn/fzf-git.sh/blob/main/fzf-git.sh
source ~/vimrc/root/fzf/fzf-git.sh

# Reference: https://github.com/junegunn/fzf#fzf-tmux-script
export FZF_TMUX=1

# Reference: https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh

# Use ** as the trigger sequence
export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'batcat -n --color=always {}' "$@" ;;
  esac
}

# sudo apt install bat
# alias "bat=batcat" in Ubuntu

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interactive-ripgrep-launcher
rfv() {
	# 1. Search for text in files using Ripgrep
	# 2. Interactively restart Ripgrep with reload action
	# 3. Open the file in Vim
	RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
	INITIAL_QUERY="${*:-}"
	IFS=: read -ra selected < <(
	FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
		fzf --ansi \
		--disabled --query "$INITIAL_QUERY" \
		--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
		--delimiter : \
		--preview 'batcat --color=always {1} --highlight-line {2}' \
		--preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
	)
	[ -n "${selected[0]}" ] && vim "${selected[0]}" "+${selected[1]}"
}

rffv() {
	# search file contains <file path>:<line number>:
	# which can be generated by
	# 1) rg --vimgrep
	# 2) :YankPathLine
	# type `gF` in vim can jump to the line
	IFS=: read -ra selected < <(
	FZF_DEFAULT_COMMAND="rg --no-line-number -e ^.+:.+: $1" \
		fzf --ansi \
		--disabled --query "$INITIAL_QUERY" \
		--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
		--delimiter : \
		--preview 'batcat --color=always {1} --highlight-line {2}' \
		--preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
	)
	[ -n "${selected[0]}" ] && vim "${selected[0]}" "+${selected[1]}"
}

# https://github.com/ColonelBuendia/rgpipe
rgi-fzf() {
	RG_PREFIX="rg -i -z --max-columns-preview --max-columns 500 --hidden --no-ignore --pre-glob \
	'*.{pdf,xl[tas][bxm],xl[wsrta],do[ct],do[ct][xm],p[po]t[xm],p[op]t,html,htm,xhtm,xhtml,epub,chm,od[stp]}' --pre ~/vimrc/root/rgpipe --files-with-matches $@"
	local file
	file="$(
			RIPGREP_CONFIG_PATH='' \
			FZF_DEFAULT_COMMAND="$RG_PREFIX . " \
			fzf --sort --preview="[[ ! -z {} ]] && rg -iz --pretty --pre ~/vimrc/root/rgpipe {q} {} | head -n 100" \
				--phony -q "" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	start "$file"
}

# https://github.com/phiresky/ripgrep-all
rga-fzf() {
	echo $@
	RG_PREFIX="RIPGREP_CONFIG_PATH='' rga --no-ignore --files-with-matches $@"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX . " \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	start "$file"
}
