/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap railwaycat/emacsmacport

apps = (
  "coreutils"
  "d2"
  "diff-so-fancy"
  "emacs-mac --with-native-comp"
  "exiftool"
  "fd"
  "ffmpeg"
  "fzf"
  "gaze"
  "git-lfs"
  "gnupg"
  "lynx"
  "ngrok"
  "postman"
  "ripgrep"
  "starship"
  "watch"
  "wget"
  "wireshark"
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
)

for app in "${apps[@]}"; do
  brew install "$app"
done
