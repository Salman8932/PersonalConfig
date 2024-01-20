#Alias for vim
alias v="vim"

#Alias for vim config
alias vi="vim ~/.vimrc"

#Alias for update and upgrade
alias iu="sudo apt install && sudo apt upgrade"

#Make and enter Directory
mkcd()
{
      mkdir -p -- "$1" && cd -P -- "$1"
}

#Clear screen and print neofetch
alias cls="clear && neofetch"

#Github update Repositories.
gpush()
{
   git add . && git commit -m "$1" && git push
}

#Sleep mode
alias sleep="systemctl suspend"

#Zathura
alias z="zathura"
