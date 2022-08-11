# Set personal aliases
# For a full list of active aliases, run `alias`.

alias laptop='bash <(curl -s https://raw.githubusercontent.com/chrisbodhi/laptop/master/laptop)'

# Replacements for built-ins
alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias cat="bat"
alias l="exa -l -a --git"

# Git
alias ga="git add"
alias gc="git commit -v"
alias gcam="git commit -a -m"
alias gcb="git checkout -b"
alias gco="git checkout"
alias gcod="git checkout develop"
alias gcom="git checkout main"
alias gcp="git cherry-pick"
alias gd="git diff"
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'
alias gprco="gh pr checkout"
alias gs="git status"
alias skunk="git branch | grep -e '^\s\syo'"

# Quick scripts
alias loc="git ls-files | xargs wc -l"
alias loc:ts="git ls-files | grep \"\.ts$\" | xargs wc -l"
alias argh="rm -rf node_modules"
alias argh-bs="argh && lerna bootstrap"
alias argh-yarn="argh && yarn"
alias not-bad="echo $1 >> ~/not-bad.txt"

# Utils
alias tim="$HOME/Code/Tim/tim -p"

# Jump to location
alias cwa="cd $HOME/code/ui/core-web-app"
alias desk="cd ~/Desktop"
alias qa="cd $HOME/code/qa"
alias ui="cd $HOME/code/ui"

# Thyme -- time tracking tool: https://github.com/sourcegraph/thyme
alias thyme_start="while true; do ~/thyme track -o ~/Desktop/thyme.json; sleep 30s; done;"
alias thyme_show="~/thyme show -i ~/Desktop/thyme.json -w stats > ~/Desktop/thyme.html"

# Quality of life
alias history="history 1"
alias moon="curl -s wttr.in/moon"
alias weather="curl -s wttr.in/15212"
