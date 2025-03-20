# dotfiles

For Nix, git, zsh, Claude Code, and Doom Emacs.

I imagine I'm committing a small heresy by not tracking my emacs config separately, but here we are.

## Setup

Clone the repo, and sync it to the home directory with the following commands

```sh
# From inside this cloned directory

# .zshrc, .vimrc
for file in .*rc; do
  ln -s "$(pwd)/$file" "$HOME/$file"
done

# git setup
files=(".gitconfig" ".gitignore_global" ".gitmessage"); for file in $files; do
  ln -s "$(pwd)/$file" "$HOME/$file"
done

for file in *.sh; do
  ln -s "$(pwd)/$file" "$HOME/$file"
done

mkdir -p "$HOME/.claude"
ln -s "$(pwd)/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Nix setup
mkdir -p "$HOME/.config/nix-darwin"
for file in nix-darwin/*; do
    ln -s "$file" "$HOME/.config/nix-darwin/$file"
done

# Install Nix
sh <(curl -L https://nixos.org/nix/install)

# Install nix-darwin
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix-darwin#max

# Rebuild nix after making changes
darwin-rebuild switch --flake ~/.config/nix-darwin#max

exec zsh
```
