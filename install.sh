#!/bin/bash

#---------------------------------------------------------------
# install.sh: cause I'm tired of doing this over and over again.
# Author: Andrew Hersh <etch.himself@gmail.com> 
#---------------------------------------------------------------

check_is_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root."
        exit
    fi
}

check_for_brew(){ # there is an assumption here that the target system has ruby installed. 

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
    brew install git tmux python vim
    brew cask install google-chrome spectacle
}

switch_default_app_links(){

    # this will be for making sure the brew versions of git, python, vim etc.
    # are correctly being run
	true;
}

install_vundle(){

	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

}

get_dotfiles(){

	git clone https://github.com/droo5ki/dotfiles.git
}

main(){

	check_is_sudo
	check_for_brew
	install_vundle
	get_dotfiles

}

main 
