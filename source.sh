# Zsh-related
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# bun completions
[ -s "/opt/homebrew/Cellar/bun/1.0.0/share/zsh/site-functions/_bun" ] && source "/opt/homebrew/Cellar/bun/1.0.0/share/zsh/site-functions/_bun"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
