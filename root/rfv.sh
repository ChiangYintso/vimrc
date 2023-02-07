#!/bin/bash

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
