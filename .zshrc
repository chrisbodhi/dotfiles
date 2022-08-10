# Uncomment for profiling with `zprof`
# zmodload zsh/zprof

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# User configuration

# env vars
# source ~/.env-vars
source ./alias.sh
source ./export.sh
source ./functions.sh
source ./source.sh

eval "$(starship init zsh)"
