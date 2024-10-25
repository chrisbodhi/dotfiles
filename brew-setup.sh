/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap railwaycat/emacsmacport

apps = (
  "emacs-mac --with-modules"
)

for app in "${apps[@]}"; do
  brew install "$app"
done

# Symlink emacs to the Application folder
ln -s /usr/local/opt/emacs-mac/Emacs.app /Applications/Emacs.app
