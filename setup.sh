#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  SKIP $(basename "$dst") — a real file exists at $dst, move it manually if you want it replaced"
    return
  fi
  ln -sf "$src" "$dst"
  echo "  $dst -> $src"
}

echo "==> Shell config"
for file in "$DOTFILES"/.*rc; do
  link "$file" "$HOME/$(basename "$file")"
done

echo "==> Git"
for file in .gitconfig .gitignore_global .gitmessage; do
  [ -f "$DOTFILES/$file" ] && link "$DOTFILES/$file" "$HOME/$file"
done

echo "==> Shell scripts"
for file in "$DOTFILES"/*.sh; do
  [[ "$(basename "$file")" == "setup.sh" ]] && continue
  link "$file" "$HOME/$(basename "$file")"
done

echo "==> Claude"
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo "==> tmux"
link "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

echo "==> nix-darwin"
for file in "$DOTFILES"/nix-darwin/*; do
  link "$file" "$HOME/.config/nix-darwin/$(basename "$file")"
done

echo ""
echo "==> TPM (tmux plugin manager)"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  echo "  already installed"
fi

echo ""
echo "==> Nix"
if ! command -v nix &>/dev/null; then
  sh <(curl -L https://nixos.org/nix/install)
else
  echo "  already installed"
fi

echo ""
echo "==> nix-darwin"
if ! command -v darwin-rebuild &>/dev/null; then
  echo "  installing (this will take a while)..."
  nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix-darwin#max
else
  echo "  already installed — run 'darwin-rebuild switch --flake ~/.config/nix-darwin#max' to apply changes"
fi

echo ""
echo "All done! Start a new shell or run: exec zsh"
echo "In tmux, install plugins with: Ctrl+Space I"
