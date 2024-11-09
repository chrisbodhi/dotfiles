# Zsh-related
export ZSH_AUTOSUGGESTIONS_PATH=$(nix build --no-link nixpkgs#zsh-autosuggestions --print-out-paths)
source "$ZSH_AUTOSUGGESTIONS_PATH/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

export ZSH_SYNTAX_HIGHLIGHTING_PATH=$(nix build --no-link nixpkgs#zsh-syntax-highlighting --print-out-paths)
source "$ZSH_SYNTAX_HIGHLIGHTING_PATH/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

autoload -U +X bashcompinit && bashcompinit

# fzf setup
source <(fzf --zsh)
