#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias config='/usr/bin/git --git-dir=/home/jonas/.cfg/ --work-tree=/home/jonas'
alias vim='nvim'

export VISUAL=nvim;
export EDITOR=nvim;
