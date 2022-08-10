# Preferred editor for local and remote sessions
export EDITOR='vim'

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

export DW_PROJECT_HOME="$HOME/code"

export WORKON_HOME="$HOME/.virtualenvs"
export CICD_SCRIPTS="$DW_PROJECT_HOME/build-scripts/cicd"
export JAVA_HOME=$(/usr/libexec/java_home -v 11)

export PLAN9=/usr/local/plan9
export PATH=$PATH:$PLAN9/bin

export PATH="$HOME/.bin:$DW_PROJECT_HOME/dev-tools/bin:$CICD_SCRIPTS:$HOME/.emacs.d/bin:$HOME/go/bin:$PATH"
