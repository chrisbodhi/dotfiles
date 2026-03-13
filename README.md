# dotfiles

For Nix, git, zsh, tmux, Claude Code, and Doom Emacs.

I imagine I'm committing a small heresy by not tracking my emacs config separately, but here we are.

## Setup

Clone the repo, then run the setup script from inside it:

```sh
git clone <this repo>
cd dotfiles
./setup.sh
```

The script symlinks all config files from the repo into the expected system locations, so any edits you make in the repo are picked up immediately. It also installs TPM, Nix, and nix-darwin if they aren't present.

After starting tmux for the first time, install plugins with `prefix + I` (that's `Ctrl+Space I`).

> If a config file already exists at a destination as a real file (not a symlink), the script will skip it and tell you — move or delete the existing file manually, then re-run.

## Upgrading Packages

To upgrade packages managed by nix-darwin (like GitHub CLI):

```sh
# Update flake inputs to get the latest package versions
cd ~/.config/nix-darwin
nix flake update

# Or update just the nixpkgs input (still updates all packages from nixpkgs)
nix flake update nixpkgs

# Rebuild to apply the updates
darwin-rebuild switch --flake ~/.config/nix-darwin#max
```

Note: You can selectively update flake inputs (like `nixpkgs`, `nix-darwin`, or `nix-homebrew`), but you cannot update individual packages within nixpkgs. Updating `nixpkgs` will update all packages in `environment.systemPackages`.
