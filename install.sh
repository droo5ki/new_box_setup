#!/bin/bash

#---------------------------------------------------------------
# install.sh: cause I'm tired of doing this over and over again.
# Author: Andrew Hersh <etch.himself@gmail.com> 
#---------------------------------------------------------------

check_for_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root."
        exit
    fi
}

check_for_os() {
    
    platform='unknown'
    unamestr=`uname`
    if [[ "$unamestr" = "Linux" ]]; then
        platform='Linux'
    elif [[ "$unamestr" = "Darwin" ]]; then
        platform='Darwin'
    fi
}

# ruby is required for brew install
check_for_brew_and_install(){ 

	if [[ -e /usr/local/bin/brew ]]; then
		echo "Brew installed, moving on."
        install_brew_stuff
	else
        echo "Installing brew..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
        install_brew_stuff
    fi
}

install_brew_stuff(){
    
    echo "Installing..."
    brew install git tmux python vim shellcheck reattach-to-user-namespace ctags tree golang
    brew cask install google-chrome spectacle iterm2 atext caffeine encryptr
}

switch_default_app_links(){

    # remove the old version of vim and symlink the brew version
    # Note: on el capitan this won't work because of System Integrity Protection
    # do this first in that case: http://stackoverflow.com/a/32661637

    sudo rm /usr/bin/vim
    sudo ln -s /usr/local/bin/vim /usr/bin/vim
}

setup_vim(){

    if [[ -e $HOME/.vim/ ]]; then
	    git clone "https://github.com/VundleVim/Vundle.vim.git" ~/.vim/bundle/Vundle.vim
    else
	    mkdir "$HOME/.vim"
	    git clone "https://github.com/VundleVim/Vundle.vim.git" ~/.vim/bundle/Vundle.vim
    fi
    if [[ -e $HOME/.vim/colors ]]; then
         cp "$HOME/.dotfiles/vim/codeschool.vim $HOME/.vim/colors/codeschool.vim"
    else
        echo "You don't seem to have a .vim/colors directory. Creating directory"
        mkdir "$HOME/.vim/colors"
        echo "Copying codeschool to vim colors directory"
        cp "$HOME/.dotfiles/vim/codeschool.vim $HOME/.vim/colors/codeschool.vim"
    fi


}

get_dotfiles(){

    cd "$HOME" || exit
	git clone https://github.com/droo5ki/dotfiles.git 
    mv dotfiles .dotfiles 
    find $HOME/.dotfiles -name '.*rc' | cut -d '/' -f5 | xargs -I {} ln -snf $HOME/.dotfiles/{} $HOME/{}
    ln -snf $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf
    ln -snf $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig


}

install_oh_my_zsh(){

    if [[ ! -e `which zsh` ]]; then
        sudo apt install -y zsh
    fi
    
    if [[ -e `which curl` ]];
    then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    else
        sudo apt install -y curl 
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
}

main(){
    
    check_for_os
	if [[ "$platform" = "Darwin" ]]; then
        check_for_brew_and_install
    fi
    install_oh_my_zsh
	get_dotfiles
	setup_vim
}

main
