# Set personal aliases
# For a full list of active aliases, run `alias`.

# Replacements for built-ins
alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias cat="bat"
alias l="eza -l -a --git"

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
alias gg="git grep"
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'
alias gprco="gh pr checkout"
alias gs="git status"
alias skunk="git branch | grep -e '^\s\syo'"

# Jump to location
alias desk="cd ~/Desktop"
alias dl="cd ~/Downloads"


# Quality of life
alias history="history 1"
alias md="mkdir -p"
alias moon="curl -s wttr.in/moon"
alias weather="curl -s wttr.in/PGH"
