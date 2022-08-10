# Uncomment for profiling with `zprof`
# zmodload zsh/zprof

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# History

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Expand history saved
HISTSIZE=99999
HISTFILESIZE=999999
SAVEHIST=$HISTSIZE

# User configuration

# env vars
# source ~/.env-vars
source $HOME/alias.sh
source $HOME/export.sh
source $HOME/functions.sh
source $HOME/source.sh

eval "$(starship init zsh)"
