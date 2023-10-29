#/bin/bash

soft_link_files=(
	.vim .ripgreprc .globalrc .tmux.conf .config/ctags .config/lazygit
	.config/vifm .gitconfig .gitconfig-ict .config/himalaya
	.local/share/bash-completion/completions/daily
)

echo_green() {
  echo -e "\033[32m$1\033[0m"
}

echo_yellow() {
	echo -e "\033[33m$1\033[0m"
}

# 检查 $VIMRC_ROOT 是否存在
if [ -z "$VIMRC_ROOT" ]; then
  # 如果不存在，则追加到 .bashrc
	echo_green "Add source ~/vimrc/root/bashrc to .bashrc:"
  echo "source ~/vimrc/root/bashrc" >> ~/.bashrc
	. ~/vimrc/root/bashrc
fi

_make_soft_link() {
	local src=$1
	local target=$2
	if ! [[ -e $target ]]; then
		ln -s $src $target
		if [ $? -eq 0 ]; then
			echo "ln -s $src $target success"
		fi
	else
		echo "File $target exists, skip."	
	fi
}

echo_green "Setup soft links:"
# nvim
# ln -s $VIMRC_ROOT/.config/nvim ~/.config/nvim
# ln -s $VIMRC_ROOT/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
mkdir -p ~/.local/share/bash-completion/completions
for f in ${soft_link_files[@]} ; do
	_make_soft_link $VIMRC_ROOT/$f ~/$f
done

mkdir -p ~/gadgets
_make_soft_link ~/gadgets ~/.vim/gadgets

echo_green "Environment variables used:"
echo DOC2="$DOC2"
echo CODE_HOME="$CODE_HOME"

echo_green "Add the following to your .bashrc if you want to use pygments for gtags:"
echo "export GTAGSLABEL=native-pygments"

echo_yellow "NOTE: Change name and email in .gitconfig if needed."

echo_green "Done!"
