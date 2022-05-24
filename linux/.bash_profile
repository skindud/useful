# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
fi

eval `ssh-agent -s`

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
