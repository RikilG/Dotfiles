#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/rikil/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rikil/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/rikil/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/rikil/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
alias dotfiles='/usr/bin/git --git-dir=/home/rikil/.dotfiles/ --work-tree=/home/rikil'
