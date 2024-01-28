# dotfiles

For git, zsh, and Doom Emacs.

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
# This will also sync the git directory...
for file in .git*; do 
  ln -s "$file" "$HOME/$file"
done

# ...which we delete here.
rm $HOME/.git

for file in *.sh; do
  ln -s "$file" "$HOME/$file"
done

exec zsh

chmod +x $HOME/brew-setup.sh
./$HOME/brew-setup.sh
```