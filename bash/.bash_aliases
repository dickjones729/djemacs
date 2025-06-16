#if [ -f "$HOME/repos/bash-git-prompt/gitprompt.sh" ]; then
#  GIT_PROMPT_ONLY_IN_REPO=0
#  GIT_PROMPT_SHOW_UPSTREAM=1
#  GIT_PROMPT_FETCH_REMOTE_STATUS=0
#  source $HOME/repos/bash-git-prompt/gitprompt.sh
#fi

# Emacs aliases
alias e='emacs -nw'
alias el='emacs -nw -q --load $HOME/.config/emacs/git-commit.el'
alias sudoel='sudo emacs -nw -q --load $HOME/.config/emacs/git-commit.el'
alias elog='emacs --no-init-file'

# Git log aliases
alias gh="git log --all --pretty=format:'%C(yellow)%h %Cred%cd %Cblue%an%Cgreen%d %Creset%s' --date=short --graph"
alias ghh="git log --first-parent HEAD --pretty=format:'%C(yellow)%h %Cred%cd %Cblue%an%Cgreen%d %Creset%s' --date=short --graph"
alias gh1="git log --all --decorate --pretty=format:'%C(yellow)%H %Cred%cd %Cblue%an %Cgreen%D %Creset%s' --date=short"
alias th="git log --no-merges --pretty=format:'%C(yellow)%h %Cred%cd %Cblue%<(15,trunc)%an%Cgreen%d %Creset%s' --date=short --graph"

export EDITOR=/usr/bin/emacs

HISTSIZE=15000

export PATH=$PATH:/home/djones/.local/bin

# Keep from getting lots of GTK warnings
export NO_AT_BRIDGE=1

export GTK_OVERLAY_SCROLLING=0

eval "$(starship init bash)"