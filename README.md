# dotfiles

For Nix, git, zsh, and Doom Emacs.

I imagine I'm committing a small heresy by not tracking my emacs config separately, but here we are.

## Setup

Clone the repo, and sync it to the home directory with the following commands

```sh
# From inside this cloned directory

# .zshrc, .vimrc
for file in .*rc; do
  ln -s "$file" "$HOME/$file"
done

# git setup
files=(".gitconfig" ".gitignore_global" ".gitmessage"); for file in $files; do
  cp "$file" "$HOME/$file"
done

for file in *.sh; do
  ln -s "$file" "$HOME/$file"
done

# Nix setup
mkdir -p "$HOME/.config/nix-darwin"
for file in nix/darwin/*; do
    ln -s "$file" "$HOME/.config/nix-darwin"
done

# Rebuild nix after making changes
darwin-rebuild switch --flake ~/.config/nix-darwin#ddw

exec zsh
```
